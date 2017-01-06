N = 2;
rho0 = 0.49;
tau0 = 0;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
g_true = [0, 2*rho0; 2*rho0, 0];
g_true = g_true(:);
c_true = [0.5;0.5];

runs = 100;
conv1 = zeros(1,runs);
conv2 = zeros(1,runs);

for i = 1:runs
    [g, c, f, ~, ~] = optimize(N, constraints, inf, 'al');
    diff1 = max(abs([g;c] - [g_true;c_true]));
    [g, c, f, ~, ~] = optimize(N, constraints, inf, 'baseline');
    diff2 = max(abs([g;c] - [g_true;c_true]));
    conv1(i) = diff1;
    conv2(i) = diff2;
end


lw=3; %Linewidth
fs=15; %Fontsize
fw='Bold'; %FontWeight
fsa=11; %Fontsize
hist1=hist(double(conv1<1e-3),2);
hist2=hist(double(conv2<1e-3),2);
bar([hist1;hist2]')
legend({'AL', 'SQP'})
Labels = {'not converged', 'converged'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontWeight', fw, 'FontSize', fs);

%% case 3
N = 2;
rho0 = 0.5;
tau0 = 0.1;

constraints.rho0 = rho0;
constraints.tau0 = tau0;
a = 0.5 - (0.5^3 - tau0)^(1/3);
b = 0.5 + (0.5^3 - tau0)^(1/3);
g_true = reshape([a, b; b, a], N, []);
g_true = g_true(:);
c_true = [0.5;0.5];

runs = 100;
conv1 = zeros(1,runs);
conv2 = zeros(1,runs);

for i = 1:runs
    [g, c, f, ~, ~] = optimize(N, constraints, inf, 'al');
    diff1 = max(abs([g;c] - [g_true;c_true]));
    [g, c, f, ~, ~] = optimize(N, constraints, inf, 'baseline');
    diff2 = max(abs([g;c] - [g_true;c_true]));
    conv1(i) = diff1;
    conv2(i) = diff2;
end


lw=3; %Linewidth
fs=15; %Fontsize
fw='Bold'; %FontWeight
fsa=11; %Fontsize
hist1=hist(double(conv1<1e-3),2);
hist2=hist(double(conv2<1e-3),2);
bar([hist1;hist2]')
legend({'AL', 'SQP'})
Labels = {'not converged', 'converged'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'FontWeight', fw, 'FontSize', fs);

%% speed comparison
rho0 = 0.49;
tau0 = 0;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
g_true = [0, 2*rho0; 2*rho0, 0];
g_true = g_true(:);
c_true = [0.5;0.5];
x_true = [g_true; c_true];

[g, c, f, ~, hist1] = optimize(N, constraints, inf, 'al',2 );
[g, c, f, ~, hist2] = optimize(N, constraints, inf, 'baseline',5 );

x1 = reshape(hist1.x, size(x_true,1),[]);
x1 = max(abs(x1 - repmat(x_true, 1, size(x1,2))), [],1);
x2 = reshape(hist2.x, size(x_true,1),[]);
x2 = max(abs(x2 - repmat(x_true, 1, size(x2,2))), [],1);
loglog(1:size(x1,2), x1, 1:size(x2,2), x2, 'LineWidth',lw);
legend({'AL', 'SQP'})
set(gca, 'FontWeight', fw, 'FontSize', fs)

%% speed comparison 2
N = 2;
rho0 = 0.5;
tau0 = 0.1;

constraints.rho0 = rho0;
constraints.tau0 = tau0;
a = 0.5 - (0.5^3 - tau0)^(1/3);
b = 0.5 + (0.5^3 - tau0)^(1/3);
g_true = reshape([a, b; b, a], N, []);
g_true = g_true(:);
c_true = [0.5;0.5];
x_true = [g_true; c_true];

[g, c, f, ~, hist1] = optimize(N, constraints, inf, 'al',2 );
[g, c, f, ~, hist2] = optimize(N, constraints, inf, 'baseline',5 );

x1 = reshape(hist1.x, size(x_true,1),[]);
x1 = max(abs(x1 - repmat(x_true, 1, size(x1,2))), [],1);
x2 = reshape(hist2.x, size(x_true,1),[]);
x2 = max(abs(x2 - repmat(x_true, 1, size(x2,2))), [],1);
loglog(1:size(x1,2), x1, 1:size(x2,2), x2, 'LineWidth',lw);
legend({'AL', 'SQP'})
set(gca, 'FontWeight', fw, 'FontSize', fs)
