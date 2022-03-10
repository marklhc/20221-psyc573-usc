data {
  int<lower=0> N1;  // number of observations (group 1)
  int<lower=0> N2;  // number of observations (group 2)
  vector<lower=0>[N1] y1;  // response time (group 1);
  vector<lower=0>[N2] y2;  // response time (group 2);
}
parameters {
  real mu1;  // mean of log(RT) (group 1)
  real<lower=0> sigma1;  // SD of log(RT) (group 2)
  real mu2;  // mean of log(RT) (group 2)
  real<lower=0> sigma2;  // SD of log(RT) (group 2)
}
model {
  // model
  // y1 ~ lognormal(mu1, sigma1);
  // y2 ~ lognormal(mu2, sigma2);
  // prior
  mu1 ~ std_normal();
  mu2 ~ std_normal();
  sigma1 ~ std_normal();
  sigma2 ~ std_normal();
}
generated quantities {
  vector<lower=0>[N1] y1_rep;  // place holder
  vector<lower=0>[N2] y2_rep;  // place holder
  for (n in 1:N1)
    y1_rep[n] = lognormal_rng(mu1, sigma1);
  for (n in 1:N2)
    y2_rep[n] = lognormal_rng(mu2, sigma2);
}
