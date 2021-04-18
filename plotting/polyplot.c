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

  char *plot_script = "gnu_singleplot_script";
  FILE *sp = fopen(plot_script,"w");
  fprintf(sp,
    "set term pngcairo; set output '%s'; plot 'polypoints.txt' w l title 'poly'",
    filepath);
  fclose(sp);

  int return_code = syscall_gnuplot("gnu_singleplot_script");

  system("rm gnu_singleplot_script");
  system("rm polypoints.txt");

  return return_code;
}

int range_plot(double *poly, double range_bottom, double range_top, char *filepath) {
  FILE *fp = fopen("polypoints.txt","w");
  double num_points = 100.0;
  double counter = (range_top - range_bottom) / num_points;
  for (double x_val = range_bottom; x_val < range_top; x_val += counter ) {
    int poly_order = order(poly);
    double y_val = eval_poly(poly, x_val);
    fprintf(fp, "%lf\t %lf\n", x_val, y_val);
  }
  fclose(fp);

  char *plot_script = "gnu_singleplot_script";
  FILE *sp = fopen(plot_script,"w");
  fprintf(sp,
    "set term pngcairo; set output '%s'; plot 'polypoints.txt' w l title 'poly'",
    filepath);
  fclose(sp);

  int return_code = syscall_gnuplot("gnu_singleplot_script");

  system("rm gnu_singleplot_script");
  system("rm polypoints.txt");

  return return_code;
}

int plot_many(double **polynomials, int num_polynomials, char *filepath) {

  FILE *fp = fopen("polypoints.txt","w");
  double range_bottom = -5.0;
  double range_top = 5.0;
  for (double x_val = range_bottom; x_val < range_top; x_val += 0.2) {
    fprintf(fp, "%lf", x_val);
    double **polypointer = polynomials;
    for (int i = 0; i < num_polynomials; i++) {
      double *temp_poly = *polypointer;

      double y_val = eval_poly(temp_poly, x_val);
      fprintf(fp, "\t %lf", y_val);

      //printf("%d\n", order(temp_poly));
      polypointer++;
    }
    fprintf(fp, "\n");
  }
  fclose(fp);

  char *plot_script = "gnu_multiplot_script";
  FILE *sp = fopen(plot_script,"w");
  fprintf(sp, "set term pngcairo; set output '%s';\nplot ", filepath);
  for (int i = 0; i < num_polynomials; i++) {
    fprintf(sp, "'polypoints.txt' using 1:%d w l title 'poly %d', \\\n", i+2, i+1);
  }
  fclose(sp);

  int return_code = syscall_gnuplot(plot_script);
  return 0;

}

int main() {
  double poly[3] = {7.0, 1.0, DBL_MIN};
  double anotherpoly[4] = {-13.0, DBL_MIN};
  double finalpoly[7] = {-12.0, 3.0, 2.0, DBL_MIN};
  double *polys[3] = { poly, anotherpoly, finalpoly };
  plot_many(polys, 3, "maxhelman.png");
  return 0;
}
