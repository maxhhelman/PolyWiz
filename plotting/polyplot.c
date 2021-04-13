#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <float.h>
#include <stdbool.h>

int order(double *poly){
  int poly_order = -1;
  int i=0;
  //while poly[i] is not the poly sentinal value, DBL_MIN
  while(poly[i] != DBL_MIN){
    //set order to largest exponent where its constant != 0
    if(poly[i]!=0.0){
      poly_order = i;
    }
    i++;
  }
  return poly_order;
}

double eval_poly(double *poly, double x){
  int poly_order = order(poly);

  // evaluate poly at specified value x
  double poly_at_x = 0.0;
  for (int i = 0; i<=poly_order; i++)
    poly_at_x += poly[i] * pow(x, i);

  return poly_at_x;
}

int syscall_gnuplot(char *scriptpath) {
  char buf[100];
  sprintf(buf, "gnuplot %s", scriptpath);
  return system(buf);
}

int plot(double *poly, char *filepath) {
  FILE *fp = fopen("polypoints.txt","w");
  double range_bottom = -20.0;
  double range_top = 20.0;
  for (double x_val = range_bottom; x_val < range_top; x_val += 0.2) {
    int poly_order = order(poly);
    double y_val = eval_poly(poly, x_val);
    fprintf(fp, "%lf\t %lf\n", x_val, y_val);
  }
  fclose(fp);

  char *plot_script = "gnu_standardplot_script";
  FILE *sp = fopen(plot_script,"w");
  fprintf(sp,
    "set term pngcairo; set output '%s'; plot 'polypoints.txt' w l",
    filepath);
  fclose(sp);

  int return_code = syscall_gnuplot("gnu_standardplot_script");
  system("rm polypoints.txt");
  return return_code;
}

int main() {
  double poly[] = {4.0, 5.0, 7.0, 8.0, DBL_MIN};
  plot(poly, "maxhelman.png");
  return 0;
}
