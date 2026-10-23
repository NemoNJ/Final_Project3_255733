clear; clc;

P = 50; Cp = 46.02; Ce = -1; Cs = 0.2;

Q_list = 20000:1000:80000;
Profit_list = zeros(size(Q_list));

for k = 1:numel(Q_list)
    Data = Estimate_Profit(P, Cp, Ce, Cs, Q_list(k), [], false);
    Profit_list(k) = Data(5);
end

[Profit_opt, idx] = max(Profit_list);
Q_opt = Q_list(idx);

fprintf('Q optimal = %d\n', Q_opt);
fprintf('Expected profit = %.2f\n', Profit_opt);

% plot กราฟ Profit vs Q
figure('Color', 'w');
plot(Q_list, Profit_list, 'b', 'LineWidth', 1.5); hold on;
plot(Q_opt, Profit_opt, 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
xlabel('Order quantity (Q)'); ylabel('Expected profit');
title(sprintf('Q* = %d', Q_opt));
grid on;
ax = gca; ax.XAxis.Exponent = 0;

% plot กราฟ normal ที่ Q optimal
Estimate_Profit(P, Cp, Ce, Cs, Q_opt);
