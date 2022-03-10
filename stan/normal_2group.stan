data {
  int<lower=0> N1;  // number of observations (group 1)
  int<lower=0> N2;  // number of observations (group 2)
  vector<lower=0>[N1] y1;  // y (group 1);
  vector<lower=0>[N2] y2;  // y (group 2);
}
parameters {
  real mu1;  // center (group 1)
  real<lower=0> sigma1;  // scale (group 1)
  real mu2;  // center (group 2)
  real<lower=0> sigma2;  // scale (group 2)
}
model {
  // model
  y1 ~ normal(mu1, sigma1);
  y2 ~ normal(mu2, sigma2);
  // prior
  mu1 ~ normal(0.5, 1);
  mu2 ~ normal(0.5, 1);
  sigma1 ~ normal(0, 1);
  sigma2 ~ normal(0, 1);
}
generated quantities {
  vector[N1] y1_rep;  // place holder
  vector[N2] y2_rep;  // place holder
  for (n in 1:N1)
    y1_rep[n] = normal_rng(mu1, sigma1);
  for (n in 1:N2)
    y2_rep[n] = normal_rng(mu2, sigma2);
}
