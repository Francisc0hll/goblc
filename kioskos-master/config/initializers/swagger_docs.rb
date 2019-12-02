class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  '1.0' => {
    controller_base_path: '',
    api_file_path: 'public/apidocs',
    camelize_model_properties: false,
    base_path: 'https://kioscos.digital.gob.cl',
    clean_directory: true
  }
})
