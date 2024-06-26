// Arkon 2003
// PS2Mouse example for drivers
// http://ragestorm.net
//
// July 2006 - fixed a bug where interrupt enabling/disabling was sent to PIC1 instead of PIC2.
// Thanks to Ven.

#include <dos.h>
#include <stdio.h>
#include <conio.h>

#define MOUSE_INTERRUPT_NO (0x74)
#define KEYB_PORT (0x60)
#define KEYB_CTRL (0x64)
#define KEYB_ACK (0xfa)

// find wheel
unsigned char ps2_init_string[] = { 0xf3, 0xc8, 0xf3, 0x64, 0xf3, 0x50, 0x00 };
// find buttons
unsigned char ps2_init_string2[] = { 0xf3, 0xc8, 0xf3, 0xc8, 0xf3, 0x50, 0x00 };
// real init
unsigned char ps2_init_string3[] = { 0xf6, 0xe6, 0xf4, 0xf3, 0x64, 0xe8, 0x03, 0x00 };
// mouse type
unsigned char extwheel = 0xff, extbuttons = 0xff;

int mx = 0, my = 0, mz = 0;

void interrupt (*old_handler)(...);
void interrupt new_handler(...);

unsigned int buttons[5] = {0, 0, 0, 0, 0};

void kbd_command_send(unsigned int port, unsigned char val)
{
 unsigned long timeout;
 unsigned char stat;

 for (timeout = 500000l; timeout != 0; timeout--)
 {
	stat = inportb(KEYB_CTRL);
	if ((stat & 0x02) == 0) break;
 }

 if (timeout != 0) outportb(port, val);
 else printf("didn't send!\n");
}

unsigned char kbd_command_read()
{
 unsigned long timeout;
 unsigned char stat, data;

 for (timeout = 500000l; timeout != 0; timeout--)
 {
	stat = inportb(KEYB_CTRL);
	if ((stat & 0x01) != 0)
	{
	 data = inportb(KEYB_PORT);
	 if ((stat & 0xC0) == 0) return data;
	}
 }
 printf("didn't read!\n");
 return -1;
}

unsigned char kbd_command_send_ack(unsigned int port, unsigned char val)
{
 unsigned int ret_val = 0;

 kbd_command_send(port, val);
 ret_val = kbd_command_read();

 if (ret_val != KEYB_ACK)
	printf("[keyboard] error: expected 0x%x, got 0x%x\n", val, ret_val);
 return ret_val;
}

void install_ps2_driver()
{
 unsigned char* ch = 0;

 printf("install_ps2_driver()");

 kbd_command_send(KEYB_CTRL, 0xa8); // enable aux

 kbd_command_send(KEYB_CTRL, 0xa9); // check aux interface
 printf("interface response: 0x%x\n", kbd_command_read());

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send_ack(KEYB_PORT, 0xf2); // identify mouse
 printf("id response: 0x%x\n", kbd_command_read());

 for (ch = ps2_init_string; *ch != '\0'; ch++) {
	kbd_command_send(KEYB_CTRL, 0xd4);
	kbd_command_send_ack(KEYB_PORT, *ch);
 }

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send_ack(KEYB_PORT, 0xf2); // identify mouse
 printf("wheel mouse was found: %d\n", (extwheel = kbd_command_read())==0x03);

 for (ch = ps2_init_string2; *ch != '\0'; ch++) {
	kbd_command_send(KEYB_CTRL, 0xd4);
	kbd_command_send_ack(KEYB_PORT, *ch);
 }

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send_ack(KEYB_PORT, 0xf2); // identify mouse
 printf(">3 buttons mouse was found: %d\n", (extbuttons = kbd_command_read())==0x04);

 for (ch = ps2_init_string3; *ch != '\0'; ch++) {
	kbd_command_send(KEYB_CTRL, 0xd4);
	kbd_command_send_ack(KEYB_PORT, *ch);
 }

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send(KEYB_PORT, 0xf4); // enable mouse
 printf("enable response: 0x%x\n", kbd_command_read());

 printf("extwheel = %d, extbuttons = %d\n", extwheel, extbuttons);

 old_handler = getvect(MOUSE_INTERRUPT_NO);
 setvect(MOUSE_INTERRUPT_NO, new_handler);

 // enable IRQ 12 at PIC 2
 outportb(0xa1, inportb(0xa1) & ~0x10);
}

int ok = 0;
void interrupt new_handler(...)
{
 static unsigned char buf[4] = {0, 0, 0, 0};
 int dx, dy, dz;
 asm cli
 kbd_command_send(KEYB_CTRL, 0xad); // disable keyb
 ok = 1;
printf("a");
 buf[0] = kbd_command_read();
 buf[1] = kbd_command_read();
 buf[2] = kbd_command_read();
 buf[3] = 0;

 if ((extwheel == 0x03) || (extbuttons == 0x04)) {

	buf[3] = kbd_command_read();
 }

 buttons[0] = buf[0] & 1;
 buttons[1] = (buf[0] & 2) >> 1;
 buttons[2] = (buf[0] & 4) >> 2;
 buttons[3] = (buf[3] & 0x10) >> 4;
 buttons[4] = (buf[3] & 0x20) >> 5;
 dx = (buf[0] & 0x10) ? buf[1] - 256 : buf[1];
 dy = (buf[0] & 0x20) ? -(buf[2] - 256) : -buf[2];
 dz = (buf[3] & 0x08) ? (buf[3]&7) - 8 : buf[3]&7;

 if (dx > 5 || dx < -5)
	dx *= 4;
 if (dy > 5 || dy < -5)
	dy *= 4;

 mx += dx;
 my += dy;
 mz += dz;

 if (mx > 80) mx = 80;
 if (mx < 1) mx = 1;
 if (my > 24) my = 24;
 if (my < 1) my = 1;

 kbd_command_send(KEYB_CTRL, 0xae); // enable keyb
 asm sti
 outportb(0xa0, 0x20); // eoi slave
 outportb(0x20, 0x20); // eoi master
}

void remove_ps2_driver()
{
 //disable IRQ 12 at PIC2
 outportb(0xa1, inportb(0xa1) | 0x10);

 setvect(MOUSE_INTERRUPT_NO, old_handler);

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send(KEYB_PORT, 0xf5); // disable aux
 printf("disable response: 0x%x\n", kbd_command_read());

 kbd_command_send(KEYB_CTRL, 0xd4); // write to aux
 kbd_command_send(KEYB_PORT, 0xff); // reset mouse
 printf("reset response: 0x%x\n", kbd_command_read());
}

void main()
{
 clrscr();
 install_ps2_driver();
 asm int 74h
 while(!buttons[0]) {
	//clrscr();
	//gotoxy(mx, my);
	//printf("�");
 }
 remove_ps2_driver();
}
