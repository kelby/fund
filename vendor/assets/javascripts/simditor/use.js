var editor = new Simditor({
  textarea: $('#editor'),
  // toolbar: ['title', 'bold', 'ol', 'ul', 'blockquote', 'code', 'table', 'link', 'image', 'hr'],
  toolbar: [
      'title',
      'bold',
      'italic',
      'underline',
      'strikethrough',
      'fontScale',
      'color',
      'ol',
      'ul',
      'blockquote',
      'code',
      'table',
      'link',
      'image',
      'hr',
      'indent',
      'outdent',
      'alignment'],
  tabIndent: false,
  placeholder: "正文内容",
  defaultImage: "/assets/default-simditor.png",

  imageButton: 'upload',
  upload: {
    url: '/redactor_rails/pictures',
    fileKey: 'file',
    params: {
      authenticity_token: "<%= form_authenticity_token %>"
    },
    connectionCount: 3,
    leaveConfirm: '正在上传文件，如果离开上传会自动取消'
  },

  pasteImage: true,
  autosave: 'z-job-new-editor-content'
});

