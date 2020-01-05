from flask_assets import Environment

assets = Environment()

assets.register('js_login', 'generated/login.js')
assets.register('js_validation', 'generated/validation.js')
assets.register('css_login', 'generated/login.css')
assets.register('js_main', 'generated/main.js')
assets.register('css_main', 'generated/main.css')
