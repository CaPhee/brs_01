$(document).ready(function(){
  config_ckediot();
});
function config_ckediot() {
  CKEDITOR.config.height = 400;
  if ($('textarea').length > 0) {
    var data = $('.ckeditor');
    $.each(data, function(i) {
      CKEDITOR.replace(data[i].id,{
        uiColor : '##D8D8D8',
        customConfig: 'customConfig_ckeditor.js',
        toolbar: [
          ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link',
            'Unlink'],
          {name: 'clipboard', items: ['Cut', 'Copy', 'Paste', 'PasteText',
            'PasteFormWord', '-', 'Undo', 'Redo']},
          {name: 'editing', items: ['Scayt']},
          {name: 'links', items: ['Link', 'Unlink', 'Anchor']},
          {name: 'insert', items: ['Table', 'HorizontaRule', 'SpecialChar']},
          {name: 'tool', items: ['Maximize']},
          {name: 'document', items: ['Source']}
        ]
      })
    });
  }
}
