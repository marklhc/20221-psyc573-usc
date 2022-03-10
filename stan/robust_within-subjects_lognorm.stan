data {
  int<lower=0> N;          // number of participants
  vector<lower=0>[N] y1;   // response for condition 1
  vector<lower=0>[N] y2;   // response for condition 2
}
parameters {
  real mu1;                // overall mean for c1 (in log)
  real dmu;                // overall mean difference between c1 and c2 (in log)
  real<lower=0> sigma;     // within-person SD (in log)
  real<lower=0> tau;       // between-person SD (assumed constant across conditions)
  vector[N] eta;           // standardized deviation (z score)
  real<lower=1> nu;        // normality parameter
}
transformed parameters {
  real mu2 = mu1 + dmu;
  vector[N] theta1;        // condition 1 means
  vector[N] theta2;        // condition 2 means
  theta1 = mu1 + tau * eta;  // non-centered parameterization
  theta2 = mu2 + tau * eta;  // non-centered parameterization
}
model {
  eta ~ student_t(nu, 0, 1);
  y1 ~ lognormal(theta1, sigma);
  y2 ~ lognormal(theta2, sigma);
  // priors
  mu1 ~ normal(0, 1);
  dmu ~ normal(0, 1);
  sigma ~ normal(0, 0.5);
  tau ~ student_t(4, 0, 0.5);
  nu ~ gamma(2, 0.1);
}
generated quantities {
  vector[N] y1_rep;  // place holder
  vector[N] y2_rep;  // place holder
  for (n in 1:N) {
    y1_rep[n] = normal_rng(theta1[n], sigma);
    y2_rep[n] = normal_rng(theta2[n], sigma);
  }
}
