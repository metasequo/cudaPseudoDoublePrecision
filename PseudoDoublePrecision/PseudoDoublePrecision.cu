#include <stdio.h>
#include <time.h>

/* ”{¸“x‚©‚ç‹[—”{¸“x‚É•ÏŠ· */
__device__ void double_to_float_float(double a, float *a_hi, float *a_lo)
{
	*a_hi = a;
	*a_lo = a - (float) a;
}

/* ‹[—”{¸“x‚©‚ç”{¸“x‚É•ÏŠ· */
__device__ void float_float_to_double(float a_hi, float a_lo, double *a)
{
	*a = a_hi + (double) a_lo;
}

/* ‹[—”{¸“x‰ÁZ */
__device__ void float_float_add(float *a_hi, float *a_lo, float b_hi, float b_lo, float c_hi, float c_lo)
{
	float sh, eh, v;

	/* TWO_SUM */
	sh = b_hi + c_hi;
	v = sh - b_hi;
	eh = (b_hi - (sh - v)) + (c_hi - v);

	/* */
	eh += (b_lo + c_lo);

	/* FAST_TWO_SUM */
	*a_hi = sh + eh;
	v = *a_hi - sh;
	*a_lo = (sh - (*a_hi - v)) + (eh - v);

}

/* ‹[—”{¸“xæZ */
__device__ void float_float_mul(float *a_hi, float *a_lo, float b_hi, float b_lo, float c_hi, float c_lo)
{
	float p1, p2, d_hi, d_lo, e_hi, e_lo, t, v;

	/* TWO_PROD */
	p1 = b_hi * c_hi;

	t = 4097.0 * b_hi;
	d_hi = t - (t - b_hi);
	d_lo = b_hi - d_hi;

	t = 4097.0 * c_hi;
	e_hi = t - (t - c_hi);
	e_lo = c_hi - e_hi;

	p2 = ((d_hi * e_hi - p1) + d_hi * e_lo + d_lo * e_hi) + d_lo * e_lo;

	/* */
	p2 += (b_hi * c_lo) + (b_lo * c_hi);

	/* FAST_TWO_SUM */
	*a_hi = p1 + p2;
	v = *a_hi - p1;
	*a_lo = (p1 - (*a_hi - v)) + (p2 - v);

}

/* ”{¸“xA‹[—”{¸“x”äŠr */
__global__ void kernel()
{
	size_t t_s, t_e;

	double a, a_dash;
	float a_hi, a_lo;
	double theta_a = 2.21315648654123846246;

	double b, b_dash;
	float b_hi, b_lo;
	double theta_b = 1.21315648654123846246;

	double c, c_dash;
	float c_hi, c_lo;
	double theta_c = 0.21315648654123846246;

	/* ƒNƒƒbƒNŠÖ”ŒÄ‚Ño‚µƒRƒXƒg */
	t_s = clock();
	t_e = clock();
	printf("clock %ld clocks\n\n", t_e - t_s);

	/* ƒTƒCƒ“ŠÖ”ŒÄ‚Ño‚µƒRƒXƒg */
	t_s = clock();
	a = sin(theta_a);
	t_e = clock();
	printf("sinf %ld clocks\n\n", t_e - t_s);

	/* ”{¸“x -> ‹[—”{¸“x•ÏŠ· */
	t_s = clock();
	double_to_float_float(a, &a_hi, &a_lo);
	t_e = clock();
	printf("double to float-float %ld clocks\n\n", t_e - t_s);

	/* ‹[—”{¸“x -> ”{¸“x•ÏŠ· */
	t_s = clock();
	float_float_to_double(a_hi, a_lo, &a_dash);
	t_e = clock();
	printf("float-float to double %ld clocks\n\n", t_e - t_s);

	/* •ÏŠ·Œ‹‰Ê */
	printf("a  = %1.15e\n", a);
	printf("a' = %1.15e\n\n", a_dash);

	b = sin(theta_b);
	c = sin(theta_c);

	/* ‰ÁZ”äŠr */
	printf("Add\n");

	t_s = clock();
	a = b + c;
	t_e = clock();
	printf("double %ld clocks\n", t_e - t_s);

	double_to_float_float(b, &b_hi, &b_lo);
	double_to_float_float(c, &c_hi, &c_lo);

	t_s = clock();
	float_float_add(&a_hi, &a_lo, b_hi, b_lo, c_hi, c_lo);
	t_e = clock();
	printf("float-float %ld clocks\n", t_e - t_s);

	float_float_to_double(a_hi, a_lo, &a_dash);

	printf("a  = %1.15e\n", a);
	printf("a' = %1.15e\n\n", a_dash);


		/* æZ”äŠr */
		printf("Multiply\n");

	b = -sin(theta_b);
	c = sin(theta_c);

	t_s = clock();
	a = b * c;
	t_e = clock();
	printf("double %ld clocks\n", t_e - t_s);


	double_to_float_float(b, &b_hi, &b_lo);
	double_to_float_float(c, &c_hi, &c_lo);


	t_s = clock();
	float_float_mul(&a_hi, &a_lo, b_hi, b_lo, c_hi, c_lo);
	t_e = clock();
	printf("float-float %ld clocks\n", t_e - t_s);

	float_float_to_double(a_hi, a_lo, &a_dash);


	printf("a  = %1.15e\n", a);
	printf("a' = %1.15e\n\n", a_dash);

	/* â‘Î’lŒvZƒRƒXƒg‘ª’è */
	long *lp_a_hi, *lp_a_lo;
	lp_a_hi = (long*) &a_hi;
	lp_a_lo = (long*) &a_lo;

	printf("FABS\n");
	t_s = clock();
	*lp_a_hi &= 0x7fffffff;
	*lp_a_lo &= 0x7fffffff;
	t_e = clock();
	printf("float-float %ld clocks\n", t_e - t_s);

	float_float_to_double(a_hi, a_lo, &a_dash);
	printf("a' = %1.15e\n", a_dash);
}

int main()
{
	int device_id = 0; /* •¡”GPU‚ª‚ ‚éê‡‚É‚Í0ˆÈŠO‚àİ’è‰Â”\ */
	cudaSetDevice(device_id);

	kernel << <1, 1 >> >();
	cudaThreadSynchronize();

	return 0;
}