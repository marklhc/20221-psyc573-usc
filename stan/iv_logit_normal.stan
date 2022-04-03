data {
  int<lower=0> N;  // number of observations
  vector[N] y;  // outcome;
  vector[N] z;  // instrument;
  int x[N];  // binary treatment/causal variable;
}
transformed data {
  vector[N] x_real = to_vector(x);
}
parameters {
  real alphax;  // regression intercept for X
  real alphay;  // regression intercept for Y
  real beta1;   // Z -> X
  real beta2;   // X -> Y
  vector[N] u;  // confounding variable
  real beta3;   // U -> Y
  real<lower=0> sigma;  // SD of prediction error for Y
}
model {
  // model
  u ~ std_normal();
  x ~ bernoulli_logit(alphax + beta1 * z + u);
  y ~ normal(alphay + beta2 * x_real + beta3 * u, sigma);
  // prior
  beta1 ~ student_t(4, 0, 5);
  beta2 ~ normal(0, 2);
  beta3 ~ normal(0, 2);
  sigma ~ student_t(4, 0, 3);
}
