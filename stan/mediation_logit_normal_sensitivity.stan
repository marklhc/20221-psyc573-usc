data {
  int<lower=0> N0;  // number of observations (control)
  int<lower=0> N1;  // number of observations (treatment)
  int y0[N0];  // outcome (control);
  int y1[N1];  // outcome (treatment);
  vector[N0] m0;  // mediator (control);
  vector[N1] m1;  // mediator (treatment);
}
parameters {
  real alpham;  // regression intercept for M
  real alphay;  // regression intercept for M
  real beta1;   // X -> M
  real beta2;   // X -> Y
  real beta3;   // M -> Y
  vector[N0] u0;  // confounding variable
  vector[N1] u1;  // confounding variable
  real beta4;   // U -> Y
  real<lower=0> sigmam;  // SD of prediction error for M
}
model {
  // model
  u0 ~ std_normal();
  u1 ~ std_normal();
  m0 ~ normal(alpham + u0, sigmam);
  m1 ~ normal(alpham + beta1 + u1, sigmam);
  y0 ~ bernoulli_logit(alphay + beta3 * m0 + beta4 * u0);
  y1 ~ bernoulli_logit(alphay + beta2 + beta3 * m1 + beta4 * u1);
  // prior
  alpham ~ normal(4.5, 4.5);
  alphay ~ normal(0, 5);
  beta1 ~ std_normal();
  beta2 ~ std_normal();
  beta3 ~ std_normal();
  beta4 ~ normal(0.5, 0.2);
  sigmam ~ student_t(4, 0, 5);
}
