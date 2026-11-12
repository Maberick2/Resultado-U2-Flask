import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get('/')
def home():
    return 'API funcionando con despliegue continuo en Docker'


@app.get('/health')
def health():
    return jsonify(status='ok', version=os.getenv('APP_VERSION', 'local'))


if __name__ == '__main__':
    app.run()
