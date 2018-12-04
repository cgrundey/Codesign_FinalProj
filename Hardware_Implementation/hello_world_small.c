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

void toAltU8(struct Alt_u128 input, alt_u8 * output);
struct Alt_u128 toAltU128(const alt_u8 * input);

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
	struct Alt_u128 mykey = toAltU128(key);
	struct Alt_u128 tempPlain = toAltU128(plainText);

	// write plaintext
	IOWR(0x5400, 0, (alt_u32)(tempPlain.low & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((tempPlain.low >> 32) & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)(tempPlain.high & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((tempPlain.high >> 32) & 0xFFFFFFFF));

	// write mykey
	IOWR(0x5400, 0, (alt_u32)(mykey.low & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((mykey.low >> 32) & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)(mykey.high & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((mykey.high >> 32) & 0xFFFFFFFF));

	// read ciphertext
	struct Alt_u128 ct;
	alt_u32 ct0 = IORD(0x5400, 0x0);
	alt_u32 ct1 = IORD(0x5400, 0x0);
	alt_u32 ct2 = IORD(0x5400, 0x0);
	alt_u32 ct3 = IORD(0x5400, 0x0);
	printf("TESTINGTINEAERNAFA: %x %x %x %x\n", ct3, ct2, ct1, ct0);
	ct.low = ct0 & (ct1 << 32);
	ct.high = ct2 & (ct3 << 32);
	toAltU8(ct, cipherText);
}

void decrypt(const alt_u8 * cipherText, const alt_u8 * key, alt_u8 * plainText) {
	struct Alt_u128 mykey = toAltU128(key);
	struct Alt_u128 tempCipher = toAltU128(cipherText);

	// write ciphertext
	IOWR(0x5400, 0, (alt_u32)(tempCipher.low & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((tempCipher.low >> 32) & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)(tempCipher.high & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((tempCipher.high >> 32) & 0xFFFFFFFF));

	// write mykey
	IOWR(0x5400, 0, (alt_u32)(mykey.low & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((mykey.low >> 32) & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)(mykey.high & 0xFFFFFFFF));
	IOWR(0x5400, 0, (alt_u32)((mykey.high >> 32) & 0xFFFFFFFF));

	// read plaintext
	struct Alt_u128 pt;
	alt_u32 pt0 = IORD(0x5400, 0x0);
	alt_u64 pt1 = IORD(0x5400, 0x0);
	alt_u32 pt2 = IORD(0x5400, 0x0);
	alt_u64 pt3 = IORD(0x5400, 0x0);
	pt.low = pt0 & (pt1 << 32);
	pt.high = pt2 & (pt3 << 32);
	toAltU8(pt, plainText);
}
