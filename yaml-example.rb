require 'yaml'

# test comment
# test
hash = { 'Foo' => 'foo',
         'Foo Bar' => 'foo_bar' }

yaml_file = 'yaml_example.yml'
File.open(yaml_file, "w") do |file|
  file.write hash.to_yaml
end

p = YAML.load_file(yaml_file)

puts p

puts p['Foo']
puts p['Foo Bar']
