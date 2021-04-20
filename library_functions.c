/*
 *  A function illustrating how to link C code to code generated from LLVM
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <errno.h>
#include <string.h>
#include <float.h>
#include <stdbool.h>
#include <unistd.h>
#include <limits.h>

double pow_operator_ff(double a, double b){
  return pow(a, b);
}

double pow_operator_fi(double a, int b){
  return pow(a, (double) b);
}

double pow_operator_if(int a, double b){
  return pow((double) a,b);
}

int pow_operator_ii(int a, int b){
  return (int) pow((double) a, (double) b);
}

double abs_operator_float(double a){
  return fabs(a);
}

int abs_operator_int(int a){
  return abs(a);
}

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

double* new_poly(double *consts, int *exponents, int arr_lengths){

  //find the order of the polynomial
  int order = -1;
  for(int i=0; i < arr_lengths; i++){
    order = exponents[i]>order ? exponents[i]: order;
  }
  if(order<0) return NULL;

  //initialize the poly array with zeros
  double *poly_arr = malloc( (order+2) * sizeof (double));

  for(int i=0; i <= order; i++)
      poly_arr[i] = 0.0;
  //terminate the poly arr with DBL_MIN
  poly_arr[order+1] = DBL_MIN;

  //fill poly array with inputted constants and exponents
  for(int i=0; i < arr_lengths; i++){
    int exponent = exponents[i];
    double constant = consts[i];
    poly_arr[exponent] = constant;
  }
  return poly_arr;

}

double* poly_addition(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  // poly_sum array will be the size of the largest input array
  int poly_sum_order = poly1_order>poly2_order ? poly1_order : poly2_order;
  double *poly_sum = malloc( (poly_sum_order+2) * sizeof (double));

  for(int i=0; i<=poly_sum_order; i++){
    double poly1_const = i<=poly1_order ? poly1[i]: 0.0;
    double poly2_const = i<=poly2_order ? poly2[i]: 0.0;
    poly_sum[i] = poly1_const + poly2_const;
  }
  poly_sum[poly_sum_order+1] = DBL_MIN;

  return poly_sum;

}

double* poly_subtraction(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  // poly_diff array will be the size of the largest input array
  int poly_diff_order = poly1_order>poly2_order ? poly1_order : poly2_order;
  double *poly_diff = malloc( (poly_diff_order+2) * sizeof (double));

  for(int i=0; i<=poly_diff_order; i++){
    double poly1_const = i<=poly1_order ? poly1[i]: 0.0;
    double poly2_const = i<=poly2_order ? poly2[i]: 0.0;
    poly_diff[i] = poly1_const - poly2_const;
  }
  poly_diff[poly_diff_order+1] = DBL_MIN;

  return poly_diff;

}


double* poly_multiplication(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  // below code is adapted from https://www.geeksforgeeks.org/multiply-two-polynomials-2/
  // poly_product array will be the size of the sum of the largest exponent on poly1 and poly2
  int poly_product_order = poly1_order+poly2_order;
  double *poly_product = malloc((poly_product_order +2) * (sizeof (double)));

  // Initialize the product polynomial with 0s as constants
  for (int i = 0; i<=poly_product_order; i++)
    poly_product[i] = 0;
  poly_product[poly_product_order+1] = DBL_MIN;

  // Loop through each term of first polynomial
  for (int i=0; i<=poly1_order; i++)
  {
    // Multiply the current term of first polynomial
    // with every term of second polynomial.
    for (int j=0; j<=poly2_order; j++)
        poly_product[i+j] += poly1[i]*poly2[j];
  }

  return poly_product;

}

double* constants_retriever(double *poly){
  int poly_order = order(poly);
  double *poly_consts = malloc((poly_order+1) * sizeof (double));

  // fill in the poly consts array
  for (int i = 0; i<=poly_order; i++)
    poly_consts[i] = poly[i];

  return poly_consts;

}

double eval_poly(double *poly, double x){
  int poly_order = order(poly);

  // evaluate poly at specified value x
  double poly_at_x = 0.0;
  for (int i = 0; i<=poly_order; i++)
    poly_at_x += poly[i] * pow(x, i);

  return poly_at_x;
}

bool equal_compare_poly(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  //if not the same order, not equal
  if(poly1_order != poly2_order)
    return false;

  // check if all poly constants are equal
  bool equal = true;
  for (int i = 0; i<= poly1_order; i++){
    if(poly1[i]!=poly2[i])
      equal = false;
  }

  return equal;

}

bool nequal_compare_poly(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  //if not the same order, not equal
  if(poly1_order != poly2_order)
    return false;

  // check if all poly constants are equal
  bool equal = true;
  for (int i = 0; i<= poly1_order; i++){
    if(poly1[i]!=poly2[i])
      equal = false;
  }

  return !equal;

}


//poly divison by float
double* poly_division(double *poly1, double denominator){

  // poly_divisor will be order 0 and represents the division by the denominator
  double *poly_divisor = malloc((2) * sizeof (double));
  poly_divisor[0] = 1.0 / denominator;
  poly_divisor[1] = DBL_MIN;

  return poly_multiplication(poly1, poly_divisor);

}



double* poly_composition(double *poly1, double *poly2){
  int poly1_order = order(poly1);
  int poly2_order = order(poly2);

  int composed_poly_order = poly1_order*poly2_order;
  double *composed_poly = malloc((composed_poly_order+2) * sizeof (double));
  // Initialize the composed polynomial with 0s as constants
  for (int i = 0; i<=composed_poly_order; i++)
    composed_poly[i] = 0;
  composed_poly[composed_poly_order+1] = DBL_MIN;

  // Loop through each term of first polynomial
  for (int i=0; i<=poly1_order; i++)
  {
    //compose this term
    int current_term_order = i*poly2_order;
    double *current_term = malloc((current_term_order+2) * sizeof (double));

    // Initialize the current poly with poly2
    for (int i = 0; i<=current_term_order; i++){
      current_term[i] = i<=poly2_order ? poly2[i]: 0.0;
    }
    current_term[current_term_order+1] = DBL_MIN;

    //foil this term
    for(int j=i; j>1; j--){
      current_term = poly_multiplication(current_term, poly2);
    }

    //handle order 0 term special case
    if(i==0)
      current_term[0] = 1.0;

    //multiply by poly1 constant for this term
    double *multiplier = malloc((2) * sizeof (double));
    multiplier[0] = poly1[i];
    multiplier[1] = DBL_MIN;
    current_term = poly_multiplication(current_term, multiplier);

    //add current term to the composed_poly
    composed_poly = poly_addition(composed_poly, current_term);
  }

  return composed_poly;

}


char* poly_to_str(double *poly){
  int poly_order = order(poly);
  const int max_digits = 350;

  //empty poly
  if(poly_order<0){
    char *poly_str = malloc( sizeof (char));
    poly_str[0] = '\0';
    return poly_str;
  }

  //this allocates the max amount of space that could possibly be needed (should probably be optimized)
  char *poly_string = malloc(poly_order* (3+(2*max_digits))* sizeof (char));
  char *poly_str_ind = poly_string;
  for (int i = poly_order; i>=0; i--){
    if(poly[i]==0.0)
      continue;

    //order 0 poly
    if(i==0){
      poly_str_ind += sprintf(poly_str_ind, poly[i]>0.0 ? "+%f" : "%f", poly[i]);
    }
    //order 1 polynomial
    else if(i==1){
      poly_str_ind += sprintf(poly_str_ind, poly[i]>0.0 ? "+%fx" : "%fx", poly[i]);
    }
    //higher order polynomials
    else{
      poly_str_ind += sprintf(poly_str_ind, i==poly_order ? "%fx^%i" : poly[i]>0.0 ? "+%fx^%i" : "%fx^%i", poly[i], i);
    }
  }

  //printf(poly_string);

  return poly_string;

}

char* poly_to_tex(double *poly){
  int poly_order = order(poly);
  const int max_digits = 350;

  //empty poly
  if(poly_order<0){
    char *poly_str = malloc( sizeof (char));
    poly_str[0] = '\0';
    return poly_str;
  }

  //this allocates the max amount of space that could possibly be needed (should probably be optimized)
  char *poly_string = malloc(poly_order* (7+(4*max_digits))* sizeof (char));
  char *poly_str_ind = poly_string;

  poly_str_ind += sprintf(poly_str_ind, "$$");

  for (int i = poly_order; i>=0; i--){
    if(poly[i]==0.0)
      continue;

    //order 0 poly
    if(i==0){
      poly_str_ind += sprintf(poly_str_ind, poly[i]>0.0 ? "+%f" : "%f", poly[i]);
    }
    //order 1 polynomial
    else if(i==1){
      poly_str_ind += sprintf(poly_str_ind, poly[i]>0.0 ? "+%fx" : "%fx", poly[i]);
    }
    //higher order polynomials
    else{
      poly_str_ind += sprintf(poly_str_ind, i==poly_order ? "%fx^{%i}" : poly[i]>0.0 ? "+%fx^{%i}" : "%fx^{%i}", poly[i], i);
    }
  }

  poly_str_ind += sprintf(poly_str_ind, "$$");

  return poly_string;

}

char* generate_texdoc(char **texdocbody, int *imgindices){

  //header and footer of the body
  char header[] = "\\documentclass{article}\n\\usepackage{graphicx}\n\\begin{document}";
  char footer[] = "\n\\end{document}";

  //header and footer to wrap filepath of image
  char imgheader[] = "\\begin{figure}[h]\n\\centering\n\\includegraphics[width=4in]{";
  char imgfooter[] = "}\n\\label{fig_sim}\n\\end{figure}";

  //find length of everything
  int len = strlen(header) + strlen(footer) + ((sizeof(imgindices)/sizeof(int)) * (strlen(imgheader) + strlen(imgfooter))) + sizeof(texdocbody);
  int num_elems = sizeof(texdocbody)/sizeof(*texdocbody);
  for(int i = 0; i < num_elems; i++) {
    len = len + strlen(texdocbody[i]) + 2;
  }

  //now, actually make the string
  char *texdoc_str = malloc(len + 100);
  char *texdoc_str_ind = texdoc_str;

  //print header
  texdoc_str_ind += sprintf(texdoc_str_ind, "%s", header);

  for(int i = 0; i < num_elems+2; i++){
    int isimg = 0;

    //check if it is an image
    for(int j = 0; j < (sizeof(imgindices)/sizeof(int)); j++){
        if((imgindices[j] == i && imgindices[j] != 0) || i == 0 && imgindices[0] == 0){
            isimg = 1;
            break;
        }
    }
    //handle non-image case
    if(isimg == 0){
        texdoc_str_ind += sprintf(texdoc_str_ind, "\n%s", texdocbody[i]);
    }

    //handle image case
    else if(isimg == 1){
        texdoc_str_ind += sprintf(texdoc_str_ind, "\n%s%s%s", imgheader, texdocbody[i], imgfooter);
    }

  }

  //print footer
  texdoc_str_ind += sprintf(texdoc_str_ind, "%s", footer);

  return texdoc_str;
}

//get poly const at ind
double poly_at_ind(double *poly, int ind){
  return poly[ind];
}

int syscall_gnuplot(char *scriptpath) {
  char buf[100];
  sprintf(buf, "gnuplot %s", scriptpath);
  return system(buf);
}

int plot(double **polynomials, int num_polynomials, char *filepath) {

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

  system("rm gnu_multiplot_script");
  system("rm polypoints.txt");

  return return_code;

}

int range_plot(double **polynomials, int num_polynomials, double range_bottom, double range_top, char *filepath) {

  FILE *fp = fopen("polypoints.txt","w");
  double num_points = 100.0;
  double counter = (range_top - range_bottom) / num_points;
  for (double x_val = range_bottom; x_val < range_top; x_val += counter ) {
    fprintf(fp, "%lf", x_val);
    double **polypointer = polynomials;
    for (int i = 0; i < num_polynomials; i++) {
      double *temp_poly = *polypointer;

      double y_val = eval_poly(temp_poly, x_val);
      fprintf(fp, "\t %lf", y_val);

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

  system("rm gnu_multiplot_script");
  system("rm polypoints.txt");

  return return_code;
}

//checks if int is inside int array
bool int_arr_contains(int x, int *arr) {
  int i = -1;
  while (arr[++i] != INT_MIN) { 
    if(arr[i] == x) {
      return true;
    }
  }
  return false;
}

//checks if float is inside float array
bool float_arr_contains(double x, double *arr) {
  int i = -1;
  while (arr[++i] != DBL_MIN) { 
    if(arr[i] == x) {
      return true;
    }
  }
  return false;
}

bool string_arr_contains(char *x, char **arr) {
  int i = -1;
  while (arr[++i]) { 
    if(arr[i] == x) {
      return true;
    }
  }
  return false;
}

//checks if poly is inside poly array
bool poly_arr_contains(double *poly, double **poly_arr) {
  int i = -1;
  while (poly_arr[++i]) {
    if(equal_compare_poly(poly, poly_arr[i])) {
      return true;
    }
  }
  return false;
}

//get int array element at ind
int arr_at_ind_i(int *arr, int ind) {
  return arr[ind];
}
//get double array element at ind
double arr_at_ind_f(double *arr, int ind) {
  return arr[ind];
}
//get bool array element at ind
bool arr_at_ind_b(bool *arr, int ind) {
  return arr[ind];
}

//set array value at ind for float arrays
double* set_arr_at_ind_f(double *arr, double el, int ind) {
  arr[ind] = el;
  return arr;
}
//set array value at ind for int arrays
int* set_arr_at_ind_i(int *arr, int el, int ind) {
  arr[ind] = el;
  return arr;
}
//set array value at ind for bool arrays
bool* set_arr_at_ind_b(bool *arr, bool el, int ind) {
  arr[ind] = el;
  return arr;
}

//instantiate float array with zeros
double* initialize_floats(int length){
  double *arr = malloc(length * sizeof (double));
  for(int i=0; i<length; i++)
    arr[i] = 0.0;
  return arr;
}
//instantiate int array with zeros
int* initialize_ints(int length){
  int *arr = malloc(length * sizeof (int));
  for(int i=0; i<length; i++)
    arr[i] = 0;
  return arr;
}

//convert an int to a float
double int_to_float(int number){
  return (double) number;
}


#ifdef BUILD_TEST
int main()
{
  double a = pow(1.0, 2.0);
  char s[] = "HELLO WORLD09AZ";
  char *c;
  double curve[] = {4.0, 5.0, 7.0, 8.0, DBL_MIN};
}
#endif
