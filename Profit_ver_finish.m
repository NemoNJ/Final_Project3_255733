function [Data, T] = Estimate_Profit(P, Cp, Ce, Cs, Q, sigma, plotFlag)

    if nargin < 6 || isempty(sigma)
        sigma = 0.2 * Q;
    end
    if nargin < 7 || isempty(plotFlag)
        plotFlag = true;
    end
    
    N = round(2 * Q);
    X = (1:N)';
    w = exp(-0.5 * ((X - Q) / sigma).^2);
    Probability = w / sum(w);
    
    Revenue = 0; Cost1 = 0; Cost2 = 0; Cost3 = 0; Profit = 0;
    T = zeros(N, 7);
    
    for i = 1:N
        x = X(i);
        Revenue_round = min(Q, x) * P;
        Cost1_round   = Q * Cp;
        Cost2_round   = max(Q - x, 0) * Ce;
        Cost3_round   = max(x - Q, 0) * Cs;
        Profit_round  = Revenue_round - (Cost1_round + Cost2_round + Cost3_round);
    
        p = Probability(i);
        Revenue = Revenue + Revenue_round * p;
        Cost1   = Cost1   + Cost1_round   * p;
        Cost2   = Cost2   + Cost2_round   * p;
        Cost3   = Cost3   + Cost3_round   * p;
        Profit  = Profit  + Profit_round  * p;
    
        T(i, :) = [x, p, Revenue_round, Cost1_round, Cost2_round, Cost3_round, Profit_round];
    end
    
    Data = [Revenue, Cost1, Cost2, Cost3, Profit];
    
    % ---------- Plot Graph ----------
    if plotFlag
        figure('Name', 'Demand Distribution', 'Color', 'w');
        hold on;
    
        idxLow  = X <  Q;
        idxHigh = X >= Q;
        h1 = area(X(idxLow),  Probability(idxLow),  'FaceColor', [0.30 0.60 0.90], ...
            'FaceAlpha', 0.5, 'EdgeColor', 'none');
        h2 = area(X(idxHigh), Probability(idxHigh), 'FaceColor', [0.90 0.40 0.30], ...
            'FaceAlpha', 0.5, 'EdgeColor', 'none');
        h3 = plot(X, Probability, 'k', 'LineWidth', 1.5);
   
        xline(Q, 'r--', sprintf('Q = %g', Q), 'LineWidth', 1.5, ...
            'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left');
        for k = [-2 -1 1 2]
            xline(Q + k*sigma, ':', sprintf('%+d\\sigma', k), ...
                'LabelVerticalAlignment', 'bottom');
        end
    
        xlabel('Demand (x)');
        ylabel('Probability');
        title({sprintf('Demand ~ Normal(\\mu = %g, \\sigma = %g)', Q, sigma), ...
            sprintf('E[Profit] = %.4g', Profit)});
        legend([h3 h1 h2], {'Probability', 'Demand < Q (excess)', ...
            'Demand \geq Q (shortage)'}, 'Location', 'northeast');
        grid on;
    
        xlim([1 N]);
        ax = gca;
        ax.XAxis.Exponent = 0;      
        xtickformat('%,d');        
        hold off;
    end

end
