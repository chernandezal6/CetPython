Update suirplus.nss_det_solicitudes_t n
Set n.ID = (Select r.ID from suirplus.suir_r_sol_asig_cedula_mv r where r.n_num_control = n.num_control and r.n_id_registro = n.id_control)
Where n.id_tipo_documento in ('C','U');

Commit;