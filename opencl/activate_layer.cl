inline double sigmoid(double z){return 1.0/(1.0+exp(-1.0 * z));} //http://simple-ml-in-action.blogspot.com/2012/05/logistic-regression-with-opencl-and-net.html

__kernel

void multiply(__global const long *params, __global const double *as, __global const double *b, __global double *cs){
  int gid = get_global_id(0);

  //https://cnugteren.github.io/tutorial/pages/page2.html
  //row major
  int M = params[2];
  int K = params[1];
  int N = params[0];

  int as_offset = K * N * gid;
  int cs_offset = M * N * gid;
  for (int m=0; m<M; m++) {
      for (int n=0; n<N; n++) {
          double acc = 0.0;
          for (int k=0; k<K; k++) {
              acc += b[k*M + m] * as[n*K + k + as_offset];
          }
          cs[n*M + m + cs_offset] = sigmoid(acc);
      }
  }
}
