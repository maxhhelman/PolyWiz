#include<stdio.h>
#include<math.h>
#include<stdlib.h>

// https://www.bragitoff.com/2017/08/plotting-exercises-c-gnuplot/

int main(){
  FILE *fp=NULL;
  fp=fopen("circle.txt","w");
  double r;
  double x,y,x0,y0;
  printf("Enter the radius of the circle to be plotted: ");
  scanf("%lf",&r);
  printf("Enter the x and y-coordinates of the center: ");
  scanf("%lf%lf",&x0,&y0);
  for(y=y0-r;y<=y0+r;y=y+0.1){
    x=sqrt(r*r-(y-y0)*(y-y0))+x0; 
    fprintf(fp,"%lf\t %lf\n",x,y);
  }
  for(y=y0+r;y>=y0-r;y=y-0.1){
    x=-sqrt(r*r-(y-y0)*(y-y0))+x0; 
    fprintf(fp,"%lf\t %lf\n",x,y);
   
  }
  fclose(fp);

  system("gnuplot 'gnuplotscript' ");

  system("rm circle.txt");
  return 0;
}