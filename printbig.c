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

/*
 * Font information: one byte per row, 8 rows per character
 * In order, space, 0-9, A-Z
 */
static const char font[] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x1c, 0x3e, 0x61, 0x41, 0x43, 0x3e, 0x1c, 0x00,
  0x00, 0x40, 0x42, 0x7f, 0x7f, 0x40, 0x40, 0x00,
  0x62, 0x73, 0x79, 0x59, 0x5d, 0x4f, 0x46, 0x00,
  0x20, 0x61, 0x49, 0x4d, 0x4f, 0x7b, 0x31, 0x00,
  0x18, 0x1c, 0x16, 0x13, 0x7f, 0x7f, 0x10, 0x00,
  0x27, 0x67, 0x45, 0x45, 0x45, 0x7d, 0x38, 0x00,
  0x3c, 0x7e, 0x4b, 0x49, 0x49, 0x79, 0x30, 0x00,
  0x03, 0x03, 0x71, 0x79, 0x0d, 0x07, 0x03, 0x00,
  0x36, 0x4f, 0x4d, 0x59, 0x59, 0x76, 0x30, 0x00,
  0x06, 0x4f, 0x49, 0x49, 0x69, 0x3f, 0x1e, 0x00,
  0x7c, 0x7e, 0x13, 0x11, 0x13, 0x7e, 0x7c, 0x00,
  0x7f, 0x7f, 0x49, 0x49, 0x49, 0x7f, 0x36, 0x00,
  0x1c, 0x3e, 0x63, 0x41, 0x41, 0x63, 0x22, 0x00,
  0x7f, 0x7f, 0x41, 0x41, 0x63, 0x3e, 0x1c, 0x00,
  0x00, 0x7f, 0x7f, 0x49, 0x49, 0x49, 0x41, 0x00,
  0x7f, 0x7f, 0x09, 0x09, 0x09, 0x09, 0x01, 0x00,
  0x1c, 0x3e, 0x63, 0x41, 0x49, 0x79, 0x79, 0x00,
  0x7f, 0x7f, 0x08, 0x08, 0x08, 0x7f, 0x7f, 0x00,
  0x00, 0x41, 0x41, 0x7f, 0x7f, 0x41, 0x41, 0x00,
  0x20, 0x60, 0x40, 0x40, 0x40, 0x7f, 0x3f, 0x00,
  0x7f, 0x7f, 0x18, 0x3c, 0x76, 0x63, 0x41, 0x00,
  0x00, 0x7f, 0x7f, 0x40, 0x40, 0x40, 0x40, 0x00,
  0x7f, 0x7f, 0x0e, 0x1c, 0x0e, 0x7f, 0x7f, 0x00,
  0x7f, 0x7f, 0x0e, 0x1c, 0x38, 0x7f, 0x7f, 0x00,
  0x3e, 0x7f, 0x41, 0x41, 0x41, 0x7f, 0x3e, 0x00,
  0x7f, 0x7f, 0x11, 0x11, 0x11, 0x1f, 0x0e, 0x00,
  0x3e, 0x7f, 0x41, 0x51, 0x71, 0x3f, 0x5e, 0x00,
  0x7f, 0x7f, 0x11, 0x31, 0x79, 0x6f, 0x4e, 0x00,
  0x26, 0x6f, 0x49, 0x49, 0x4b, 0x7a, 0x30, 0x00,
  0x00, 0x01, 0x01, 0x7f, 0x7f, 0x01, 0x01, 0x00,
  0x3f, 0x7f, 0x40, 0x40, 0x40, 0x7f, 0x3f, 0x00,
  0x0f, 0x1f, 0x38, 0x70, 0x38, 0x1f, 0x0f, 0x00,
  0x1f, 0x7f, 0x38, 0x1c, 0x38, 0x7f, 0x1f, 0x00,
  0x63, 0x77, 0x3e, 0x1c, 0x3e, 0x77, 0x63, 0x00,
  0x00, 0x03, 0x0f, 0x78, 0x78, 0x0f, 0x03, 0x00,
  0x61, 0x71, 0x79, 0x5d, 0x4f, 0x47, 0x43, 0x00
};

void printbig(int c)
{
  int index = 0;
  int col, data;
  if (c >= '0' && c <= '9') index = 8 + (c - '0') * 8;
  else if (c >= 'A' && c <= 'Z') index = 88 + (c - 'A') * 8;
  do {
    data = font[index++];
    for (col = 0 ; col < 8 ; data <<= 1, col++) {
      char d = data & 0x80 ? 'X' : ' ';
      putchar(d); putchar(d);
    }
    putchar('\n');
  } while (index & 0x7);
}

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

double* new_poly(double *consts, int consts_length, int *exponents, int exponents_length){
  //if unequal size of consts and exponents arrays
  if ( consts_length != exponents_length )
    return NULL;

  //find the order of the polynomial
  int order = -1;
  for(int i=0; i < exponents_length; i++){
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
  for(int i=0; i < exponents_length; i++){
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

//get poly const at ind
double poly_at_ind(double *poly, int ind){
  return poly[ind];
}

int plot(double *poly) {
  FILE *fp = fopen("plotting/polypoints.txt","w");
  double range_bottom = -20.0;
  double range_top = 20.0;
  for (double x_val = range_bottom; x_val < range_top; x_val += 0.2) {
    int poly_order = order(poly);
    double y_val = eval_poly(poly, x_val);
    fprintf(fp, "%lf\t %lf\n", x_val, y_val);
  }
  fclose(fp);
  int return_code = system("gnuplot plotting/gnu_plotscript");
  system("rm plotting/polypoints.txt");
  return return_code;
}

int range_plot(double *poly, double range_bottom, double range_top) {
  FILE *fp = fopen("plotting/polypoints.txt","w");
  double num_points = 100.0;
  double counter = (range_top - range_bottom) / num_points;
  for (double x_val = range_bottom; x_val < range_top; x_val += counter ) {
    int poly_order = order(poly);
    double y_val = eval_poly(poly, x_val);
    fprintf(fp, "%lf\t %lf\n", x_val, y_val);
  }
  fclose(fp);
  int return_code = system("gnuplot plotting/gnu_rangeplotscript");
  system("rm plotting/polypoints.txt");
  return return_code;
}

#ifdef BUILD_TEST
int main()
{
  double a = pow(1.0, 2.0);
  char s[] = "HELLO WORLD09AZ";
  char *c;
  double curve[] = {4.0, 5.0, 7.0, 8.0, DBL_MIN};
  plot(curve);
  for ( c = s ; *c ; c++) printbig(*c);
}
#endif
