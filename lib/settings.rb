require 'yaml'

class Settings
  def self.call
    new.send(:params)
  end

  private

  def params
    YAML.load_file(File.join('config', 'settings.yml'))
  end
end
