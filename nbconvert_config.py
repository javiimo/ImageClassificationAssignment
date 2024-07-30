import os

c = get_config()

# Configure TagRemovePreprocessor
c.TagRemovePreprocessor.enabled = True
c.TagRemovePreprocessor.remove_input_tags = {'hide-input'}

# Configure the exporter
c.NbConvertApp.export_format = 'html'
c.HTMLExporter.template_file = os.path.abspath(os.path.join(os.path.dirname(__file__), 'custom_template.tpl'))