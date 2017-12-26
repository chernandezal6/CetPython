BEGIN

  execute immediate 'Update suirplus.seg_usuario_t set PASSWORD = md5_digest(''123'')';
  execute immediate 'commit';

END;
/
exit