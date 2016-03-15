CKEDITOR.editorConfig = function(config)
{
  config.toolbar = [
    { name: 'document', groups: [ 'doctools' ], items: [ 'Preview'] },
    { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo' ] },
    { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
    '/',
    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
    { name: 'paragraph', groups: [ 'list', 'blocks', 'align' ], items: [ 'NumberedList', 'BulletedList', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] }
    // '/',
    // { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
    // '/',
    // { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
    // { name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
  ];

  config.enterMode = CKEDITOR.ENTER_BR;

  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';
};