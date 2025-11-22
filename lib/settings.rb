require 'yaml'

class Settings
  ROOT_DIR = File.expand_path('..', __dir__)

  def self.call
    new.send(:params)
  end

  private

  def params
    read_file = File.join(ROOT_DIR, 'config', 'settings.yaml')

    @params ||= YAML.load_file(read_file)
  end
end
