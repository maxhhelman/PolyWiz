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

int main() {
  double poly[] = {4.0, 5.0, 7.0, 8.0, DBL_MIN};
  FILE *fp = fopen("polypoints.txt","w");
  double num_points = 100.0;
  double range_bottom = -10.0;
  double range_top = 10.0;
  for (double x_val = range_bottom; x_val < range_top; x_val += 0.2 ) {
    int poly_order = order(poly);
    double y_val = eval_poly(poly, x_val);
    fprintf(fp, "%lf\t %lf\n", x_val, y_val);
  }
  fclose(fp);
  system("gnuplot 'gnuplotscript' ");
  system("rm polypoints.txt");
  return 0;
}
