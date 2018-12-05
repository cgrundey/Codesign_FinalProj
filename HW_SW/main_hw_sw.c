// ECE 4530 Semester Project Source Code
// Colin Grundey
// Brian Pangburn
// Wes Hirsheimer

#define ALT_CI_PERM1_N 0x00
#define ALT_CI_PERM1(A, B) __builtin_custom_inpp(ALT_CI_PERM1_N, (A), (B))
#define ALT_CI_SUBHELP_N 0x01
#define ALT_CI_SUBHELP(A, B) __builtin_custom_inpp(ALT_CI_SUBHELP_N, (A), (B))
#define ALT_CI_INVSUBHELP_N 0x02
#define ALT_CI_INVSUBHELP(A, B) __builtin_custom_inpp(ALT_CI_INVSUBHELP_N, (A), (B))
#define ALT_CI_ADDROUNDCONST_N 0x03
#define ALT_CI_ADDROUNDCONST(A, B) __builtin_custom_inpp(ALT_CI_ADDROUNDCONST_N, (A), (B))

#include "sys/alt_stdio.h"
#include "alt_types.h"

// Include other libraries as desired
#include "system.h"
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
  //alt_u8 ptext[16] = { 0xde, 0xad, 0xbe, 0xef, 0xfe, 0xfe, 0xba, 0xbe, 0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0 };
  alt_u8 ptext[16] = { 0x98, 0x76, 0x54, 0x32, 0x10, 0xfe, 0xdc, 0xba, 0x77, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11, 0x00};
  // Secret key for use in encryption and decryption - try various keys
  //alt_u8 key[16] = { 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xff, 0xee, 0xdd, 0xcc, 0xaa, 0x99, 0x88, 0x77 };
  alt_u8 key[16] = { 0x12, 0x34 , 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00, 0x11};
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



struct Alt_u128 enRoundKey(struct Alt_u128 key) {
	 struct Alt_u128 roundKey;

     alt_u64 temp = perm1(key.low);
     roundKey.low = temp ^ key.high;
     roundKey.high = temp;

     return roundKey;
}

struct Alt_u128 deRoundKey(struct Alt_u128 key) {
     struct Alt_u128 roundKey;

     alt_u64 temp = perm1(key.high);
     roundKey.high  = key.high ^ key.low;
     roundKey.low = temp;

     return roundKey;
}

alt_u64 perm1(alt_u64 input) {
	 alt_u32 low = ALT_CI_PERM1((input & 0xFFFFFFFF), 0x0);
	 alt_u32 high = ALT_CI_PERM1((input >> 32), 0x0);
	 alt_u64 output = ((alt_u64)high << 32) | (alt_u64)low;

     return output;
}

alt_u64 perm2(alt_u64 input) {
     // circular shift to the right 21 bits
	 alt_u64 bottom = input >> 43;
	 alt_u64 top = (input & 0x7FFFFFFFFFF) << 21;
     alt_u64 output = top | bottom;
     return output;
}

alt_u64 perm2inv(alt_u64 input) {
     // circular shift to the right 43 bits
	 alt_u64 top = ((input & 0x1FFFFF) << 43);
	 alt_u64 bottom = (input >> 21);
     alt_u64 output = top | bottom;
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
          temp = ALT_CI_SUBHELP(temp, 0x0);
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

alt_u64 invSubBytes(alt_u64 input) {
     alt_u64 output = 0x0000000000000000;
     alt_u64 output2 = 0x0000000000000000;

     for (int i = 0; i < 16; i++) {
          // get a nibbles worth of data
          alt_u4 temp = input >> (i*4);
          temp = temp & 0xF;
          // perform sbox operation
          temp = ALT_CI_INVSUBHELP(temp, 0x0);
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
     alt_u32 in20to14test = ALT_CI_ADDROUNDCONST(in20to14, i) << 14;
     //printf("test:%x\n", (alt_u32)ALT_CI_ADDROUNDCONST(in20to14, i));
     //printf("good:%x\n", (alt_u32)(in20to14 ^ rConstant));
     in20to14 = (in20to14 ^ rConstant) << 14;

     output = output | in20to14;

     return output;
}

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

	toAltU8(pt, plainText);
}
