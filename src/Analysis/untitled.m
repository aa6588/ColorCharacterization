for i = 1:105
[CI_value(i), delta_uv_value(i)] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), w_uv(1:2), selected_points(i,:));
end

figure;
h = histogram(currentData.delta_uv_2_recenter,15);
xlabel('\delta_u_v')
ylabel('frequency')
title('[VR] Frequency \delta_u_v')
h.EdgeColor = [0, 0.4470, 0.7410];
h.LineWidth = 1;

figure;
h = histogram(delta_uv_value,15);
xlabel('\delta_u_v')
ylabel('frequency')
title('random Frequency \delta_u_v')
h.EdgeColor = [0, 0.4470, 0.7410];
h.LineWidth = 1;