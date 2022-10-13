extern void scroll_up1 (int x,int y,int l,int h, char speed);
extern void scroll_up2 (int x,int y,int l,int h, char speed);                                                                                                                                                  

void scroll_up (int x, int y, int l, int h, char speed)
{
if (gmode == 1)
 scroll_up1 (x,y,l,h,speed);
else
 scroll_up2 (x,y,l,h,speed);
}
