data {
  int<lower=0> J;         // number of clusters (e.g., studies, persons)
  int y[J];               // number of "1"s in each cluster
  int N[J];               // sample size for each cluster
}
parameters {
  vector<lower=0, upper=1>[J] theta;   // cluster-specific probabilities
  real<lower=0, upper=1> mu;     // overall mean probability
  real<lower=0> kappa;           // overall concentration
}
model {
  y ~ binomial(N, theta);              // each observation is binomial
  theta ~ beta_proportion(mu, kappa);  // prior; Beta2 dist
  mu ~ beta(1.5, 1.5);           // weak prior
  kappa ~ gamma(.01, .01);       // prior recommended by Kruschke
}
