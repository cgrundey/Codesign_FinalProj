// ECE 4530 Semester Project Source Code
// Colin Grundey
// Brian Pangburn
// Wes Hirsheimer

#include "sys/alt_stdio.h"
#include "alt_types.h"

// Include other libraries as desired

#include "io.h"

// Include the below timer prototypes -- mandatory inclusion

void resetTimer();
void startTimer();
void stopTimer();
alt_u32 readTimer();

// Include other function prototypes, variables, and declarations as desired

typedef char alt_u4;

struct Alt_u128 {
	alt_u64 high;
	alt_u64 low;
};

// helper sub-functions
struct Alt_u128 enRoundKey(struct Alt_u128 key);
struct Alt_u128 deRoundKey(struct Alt_u128 key);
alt_u64 perm1(alt_u64 input);
alt_u64 perm2(alt_u64 input);
alt_u64 perm2inv(alt_u64 input);
alt_u4 subHelp(alt_u4 input);
alt_u64 subBytes(alt_u64 input);
alt_u4 invSubHelp(alt_u4 input);
alt_u64 invSubBytes(alt_u64 input);
alt_u64 addRoundConstant(alt_u64 input, int i);

// Include the below function prototypes -- mandatory inclusion

void dumpToScreen(alt_u8 *); // mandatory inclusion
void encrypt(const alt_u8 *, const alt_u8 *, alt_u8 *);
void decrypt(const alt_u8 *, const alt_u8 *, alt_u8 *);

// Do not alter the contents of main()!
int main()
{

  alt_putstr("Hello from Nios II!\n"); // recommended

  // string declarations

  // Plaintext to be encrypted - try various test vectors
  alt_u8 ptext[16] = { 0xde, 0xad, 0xbe, 0xef, 0xfe, 0xfe, 0xba, 0xbe, 0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0 };

  // Secret key for use in encryption and decryption - try various keys
  alt_u8 key[16] = { 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xff, 0xee, 0xdd, 0xcc, 0xaa, 0x99, 0x88, 0x77 };

  // Ciphertext after encryption - starts at zero, and is overwritten by ciphertext after encryption
  alt_u8 ctext[16] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

  // variable declarations
  alt_u32 encrypttime, decrypttime;

  resetTimer();
  alt_printf("Time reset\n");

  alt_putstr("plaintext before encrypt\n");
  dumpToScreen(ptext);

  alt_printf("Time start encrypt: %x \n", readTimer());

  startTimer();
  encrypt(ptext, key, ctext);
  stopTimer();

  encrypttime = readTimer();
  alt_printf("Encrypt time: %x \n", encrypttime);

  alt_putstr("plaintext after encrypt\n");
  dumpToScreen(ptext);

  alt_putstr("ciphertext after encrypt\n");
  dumpToScreen(ctext);

  resetTimer();
  alt_printf("Time start decrypt: %x \n", readTimer());

  startTimer();
  decrypt(ctext, key, ptext);
  stopTimer();

  decrypttime = readTimer();
  alt_printf("Decrypt time: %x \n", decrypttime);

  alt_putstr("ciphertext after decrypt\n");
  dumpToScreen(ctext);

  alt_putstr("plaintext after decrypt\n");
  dumpToScreen(ptext);

  alt_printf("Total time: %x \n", encrypttime + decrypttime);

  /* Event loop never exits. */
  while (1);

  return 0;
}

void dumpToScreen(alt_u8 * a){
	for (int i = 0; i < 16; i++)
		alt_printf("%x ", *a++);
	alt_printf("\n");
}

// Add other functions as desired

void resetTimer() {
	/* Write 3 to reset the timer */
	IOWR(0x5000, 0, 0x3);
}
void startTimer() {
	/* Write 1 to start the timer */
	IOWR(0x5000, 0, 0x1);
}
void stopTimer() {
	/* Write 2 to stop the timer */
	IOWR(0x5000, 0, 0x2);
}
alt_u32 readTimer() {
	/* Read the timer value */
	return IORD(0x5000, 0x0);
}

// Round key for encryption
struct Alt_u128 enRoundKey(struct Alt_u128 key) {
	 struct Alt_u128 roundKey;

     alt_u64 temp = perm1(key.low);
     roundKey.low = temp ^ key.high;
     roundKey.high = temp;

     return roundKey;
}

// Round key for decryption
struct Alt_u128 deRoundKey(struct Alt_u128 key) {
     struct Alt_u128 roundKey;

     alt_u64 temp = perm1(key.high);
     roundKey.high  = key.high ^ key.low;
     roundKey.low = temp;

     return roundKey;
}

// Permutation 1
alt_u64 perm1(alt_u64 input) {
     // Partition into 16 bit segments
     alt_u64 in3 = 0xFFFF & input;
     alt_u64 in2 = (input >> 16) & 0xFFFF;
     alt_u64 in1 = (input >> 32) & 0xFFFF;
     alt_u64 in0 = (input >> 48);

     alt_u64 output = (in1 << 48) | (in0 << 32) | (in3 << 16) | in2;

     return output;
}

// Permutation 2
alt_u64 perm2(alt_u64 input) {
     // circular shift to the right 21 bits
	 alt_u64 bottom = input >> 43;
	 alt_u64 top = (input & 0x7FFFFFFFFFF) << 21;
     alt_u64 output = top | bottom;
     return output;
}

// Permutation 2 invedrse
alt_u64 perm2inv(alt_u64 input) {
     // circular shift to the right 43 bits
	 alt_u64 top = ((input & 0x1FFFFF) << 43);
	 alt_u64 bottom = (input >> 21);
     alt_u64 output = top | bottom;
     return output;
}

// S-box helper function
alt_u4 subHelp(alt_u4 input) {
     alt_u4 output;

     // sbox
     switch (input) {
          case 0x0:
               output = 0xC;
               break;
          case 0x1:
               output = 0x9;
               break;
          case 0x2:
               output = 0xD;
               break;
          case 0x3:
               output = 0x2;
               break;
          case 0x4:
               output = 0x5;
               break;
          case 0x5:
               output = 0xF;
               break;
          case 0x6:
               output = 0x3;
               break;
          case 0x7:
               output = 0x6;
               break;
          case 0x8:
               output = 0x7;
               break;
          case 0x9:
               output = 0xE;
               break;
          case 0xA:
               output = 0x0;
               break;
          case 0xB:
               output = 0x1;
               break;
          case 0xC:
               output = 0xA;
               break;
          case 0xD:
               output = 0x4;
               break;
          case 0xE:
               output = 0xB;
               break;
          case 0xF:
               output = 0x8;
               break;
          default:
               output = 0x0;
     }

     return output;
}

alt_u64 subBytes(alt_u64 input) {
     alt_u64 output = 0x0000000000000000;
     alt_u64 output2 = 0x0000000000000000;

     for (int i = 0; i < 16; i++) {
          // get a nibbles worth of data
          alt_u4 temp = input >> (i*4);
          temp = temp & 0xF;
          // perform sbox operation
          temp = subHelp(temp);
          if (i < 8) {
        	  output = output | (temp << (i*4));
          }
          else {
        	  output2 = output2 | (temp << (i*4));
          }
     }
     output = (output2 << 32) | (output & 0xFFFFFFFF);

     return output;
}

// Inverse S-box
alt_u4 invSubHelp(alt_u4 input) {
     alt_u4 output;

     // sbox
     switch(input) {
          case 0x0:
               output = 0xA;
               break;
          case 0x1:
               output = 0xB;
               break;
          case 0x2:
               output = 0x3;
               break;
          case 0x3:
               output = 0x6;
               break;
          case 0x4:
               output = 0xD;
               break;
          case 0x5:
               output = 0x4;
               break;
          case 0x6:
               output = 0x7;
               break;
          case 0x7:
               output = 0x8;
               break;
          case 0x8:
               output = 0xF;
               break;
          case 0x9:
               output = 0x1;
               break;
          case 0xA:
               output = 0xC;
               break;
          case 0xB:
               output = 0xE;
               break;
          case 0xC:
               output = 0x0;
               break;
          case 0xD:
               output = 0x2;
               break;
          case 0xE:
               output = 0x9;
               break;
          case 0xF:
               output = 0x5;
               break;
          default:
               output = 0x0;
     }

     return output;
}

alt_u64 invSubBytes(alt_u64 input) {
     alt_u64 output = 0x0000000000000000;
     alt_u64 output2 = 0x0000000000000000;

     for (int i = 0; i < 16; i++) {
          // get a nibbles worth of data
          alt_u4 temp = input >> (i*4);
          temp = temp & 0xF;
          // perform sbox operation
          temp = invSubHelp(temp);
          if (i < 8) {
        	  output = output | (temp << (i*4));
          }
          else {
              output2 = output2 | (temp << (i*4));
          }
     }
     output = (output2 << 32) | (output & 0xFFFFFFFF);

     return output;
}

// Round Constant Helper Function
alt_u64 addRoundConstant(alt_u64 input, int i) {
     alt_u64 output = input;
     // clear bits 20:14 to be
     output = output & 0xFFFFFFFFFFE03FFF;
     // get bits 20:14 of the input
     alt_u32 in20to14 = (input >> 14) & 0x7F;
     // get the correct round constant for i
     alt_u8 rConstant;
     switch (i) {
     	 case 0x0:
     		 rConstant = 0x5A;
     		 break;
     	 case 0x1:
     		 rConstant = 0x34;
     	     break;
     	 case 0x2:
     		 rConstant = 0x73;
     		 break;
     	 case 0x3:
     		 rConstant = 0x66;
     		 break;
     	 case 0x4:
     		 rConstant = 0x57;
     		 break;
     	 case 0x5:
     		 rConstant = 0x35;
     		 break;
     	 case 0x6:
     		 rConstant = 0x71;
     		 break;
     	 case 0x7:
     		 rConstant = 0x62;
     		 break;
     	 case 0x8:
     		 rConstant = 0x5F;
     		 break;
     	 case 0x9:
     		 rConstant = 0x25;
     		 break;
     	 case 0xA:
     		 rConstant = 0x51;
     		 break;
     	 case 0xB:
     		 rConstant = 0x22;
     		 break;
     	 default:
     		 rConstant = 0x00;
     }
     // make the bits for 20:14 of the output
     in20to14 = (in20to14 ^ rConstant) << 14;
     output = output | in20to14;

     return output;
}

// convert pointer to 128-bit
struct Alt_u128 toAltU128(const alt_u8 * input) {
	struct Alt_u128 output;
	output.high = 0;
	output.low = 0;

	for (int i = 15; i >= 0; i--) {
		// get a bytes worth of data
	    alt_u64 temp = input[i];
	    temp = temp & 0xFF;

	    if (i < 8) {
	     	  output.high = output.high | (temp << ((7-i)*8));
	    }
	    else {
	       	  output.low = output.low | (temp << ((15-i)*8));
	    }
	}

	return output;
}

// Convert back to pointer 
void toAltU8(struct Alt_u128 input, alt_u8 * output) {
	for (int i = 0; i < 16; i++) {
		alt_u8 temp;
		if (i < 8) {
			temp = input.high >> (8*(7-i));
		}
		else {
			temp = input.low >> (15-i)*8;
		}
	    temp = temp & 0xFF;

	    output[i] = temp;
	}

}

// encryption algorithm
void encrypt(const alt_u8 * plainText, const alt_u8 * key, alt_u8 * cipherText) {
	struct Alt_u128 roundKey = toAltU128(key);
	struct Alt_u128 tempPlain = toAltU128(plainText);
	alt_u64 high = tempPlain.high;
	alt_u64 low = tempPlain.low;

	for (int i = 0; i < 12; i++) {
		// generate the round key
		roundKey = enRoundKey(roundKey);

		high = high ^ roundKey.high;
		high = subBytes(high);

		low = addRoundConstant(low, i);
		low = low ^ roundKey.low;
		low = perm1(low);
		low = perm2(low);

		alt_u64 temp = high;
		high = high ^ low;
		low = temp;
	}
	struct Alt_u128 ct;
	ct.high = high;
	ct.low = low;

	toAltU8(ct, cipherText);
}

// decryption algorithm
void decrypt(const alt_u8 * cipherText, const alt_u8 * key, alt_u8 * plainText) {
	struct Alt_u128 roundKey = toAltU128(key);
	struct Alt_u128 tempCipher = toAltU128(cipherText);
	alt_u64 high = tempCipher.high;
	alt_u64 low = tempCipher.low;

	for (int i = 11; i >= 0; i--) {
		// generate round key
		if (i != 11) {
			roundKey = deRoundKey(roundKey);
		}
		alt_u64 temp = low;
		low = high ^ low;
		low = perm2inv(low);
		low = perm1(low);

		high = invSubBytes(temp);
		high = high ^ roundKey.high;

		low = low ^ roundKey.low;
		low = addRoundConstant(low, i);
	}
	struct Alt_u128 pt;
	pt.high = high;
	pt.low = low;

	toAltU8(pt, plainText); // convert back
}
