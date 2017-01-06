N = 2;
n = 30;
lw=3; %Linewidth
fs=15; %Fontsize
fw='Bold'; %FontWeight
fsa=11; %Fontsize
%% case 1
rho0s = linspace(0.01, 0.99, n);
tau0s = sqrt(rho0s.^3);
g_true = reshape([1; 0; 0; 0], N, []);
g_true = g_true(:);
f_true = 0;
dg = zeros(N,N,n);
dc = zeros(1,n);
difference = zeros(1,n);
for i = 1:n
    rho0 = rho0s(i);
    tau0 = tau0s(i);
    c_true = min(sqrt(rho0),1-sqrt(rho0));
    constraints.rho0 = rho0;
    constraints.tau0 = tau0;
    [g, c, f] = optimize(N, constraints, inf, 'al');
    c = min(c);
    g = reshape(g, N, []);
    if g(1,1) < g(2, 2)
        t = g(1, 1);
        g(1, 1) = g(2, 2);
        g(2, 2) = t;
    end
    g = g(:);
    difference(i) = max(abs([g;c]-[g_true;c_true]));
%     dg(:,:,i) = abs(g-g_true);
%     dc(i) = abs(c-c_true);
end
figure
% subplot(2,2,1)
% plot(rho0s, squeeze(dg(1,1,:)), 'LineWidth', lw);
% subplot(2,2,2)
% plot(rho0s, squeeze(dg(1,2,:)), 'LineWidth', lw);
% subplot(2,2,3)
% plot(rho0s, squeeze(dg(2,2,:)), 'LineWidth', lw);
% subplot(2,2,4)
plot(rho0s, difference, 'LineWidth', lw);
xlabel('\rho_0', 'FontWeight', fw, 'FontSize', fs)
ylabel('||(g,c)-(g^*, c^*)||','FontWeight', fw, 'FontSize', fs)

%% case 2
rho0s = linspace(0.01, 0.49, n);
tau0s = 0;
dg = zeros(N,N,n);
dc = zeros(1,n);
difference = zeros(1,n);
for i = 1:n
    rho0 = rho0s(i);
    tau0 = tau0s;
    g_true = reshape([0, 2*rho0; 2*rho0, 0], N, []);
    g_true = g_true(:)
    c_true = 0.5;
    constraints.rho0 = rho0;
    constraints.tau0 = tau0;
    [g, c, f] = optimize(N, constraints, inf, 'al');
    c = min(c);
%     g = reshape(g, N, []);
    g = g(:);
    difference(i) = max(abs([g;c]-[g_true;c_true]));
%     dg(:,:,i) = abs(g-g_true);
%     dc(i) = abs(c-c_true);
end
figure
% subplot(2,2,1)
% plot(rho0s, squeeze(dg(1,1,:)), 'LineWidth', lw);
% subplot(2,2,2)
% plot(rho0s, squeeze(dg(1,2,:)), 'LineWidth', lw);
% subplot(2,2,3)
% plot(rho0s, squeeze(dg(2,2,:)), 'LineWidth', lw);
% subplot(2,2,4)
% plot(rho0s, dc, 'LineWidth', lw);
plot(rho0s, difference, 'LineWidth', lw);
xlabel('\rho_0', 'FontWeight', fw, 'FontSize', fs)
ylabel('||(g,c)-(g^*, c^*)||','FontWeight', fw, 'FontSize', fs)

%% case 3
rho0s = 0.5;
tau0s = linspace(0, 0.125, n);
dg = zeros(N,N,n);
dc = zeros(1,n);
difference = zeros(1,n);
for i = 1:n
    rho0 = rho0s;
    tau0 = tau0s(i);
    a = 0.5 - (0.5^3 - tau0)^(1/3);
    b = 0.5 + (0.5^3 - tau0)^(1/3);
    g_true = reshape([a, b; b, a], N, []);
    g_true = g_true(:);
    c_true = 0.5;
    constraints.rho0 = rho0;
    constraints.tau0 = tau0;
    [g, c, f] = optimize(N, constraints, inf, 'al', 2);
    c = min(c);
%     g = reshape(g, N, []);
    g = g(:);
    difference(i) = max(abs([g;c]-[g_true;c_true]));
%     dg(:,:,i) = abs(g-g_true);
%     dc(i) = abs(c-c_true);
end
figure
% subplot(2,2,1)
% plot(rho0s, squeeze(dg(1,1,:)), 'LineWidth', lw);
% subplot(2,2,2)
% plot(rho0s, squeeze(dg(1,2,:)), 'LineWidth', lw);
% subplot(2,2,3)
% plot(rho0s, squeeze(dg(2,2,:)), 'LineWidth', lw);
% subplot(2,2,4)
% plot(rho0s, dc, 'LineWidth', lw);
plot(tau0s, difference, 'LineWidth', lw);
xlabel('\rho_0', 'FontWeight', fw, 'FontSize', fs)
ylabel('||(g,c)-(g^*, c^*)||','FontWeight', fw, 'FontSize', fs)