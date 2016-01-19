Gem::Specification.new do |s|
  s.name         = 'knn'
  s.version      = '0.1.0'
  s.licenses     = ['MIT']
  s.summary      = "Simple KNN implementation"
  s.authors      = ["Igor Suleymanov"]
  s.email        = 'igorsuleymanoff@gmail.com'
  s.files        = Dir['lib/**/**/*']
  s.homepage     = 'https://github.com/radiohead/knn'

  s.add_dependency 'descriptive_statistics', '~> 2.5'
end
