# Detector de flores

![enter image description here](https://github.com/manoelfilho/flower-recognition/blob/master/flowers-recognition/flower%20recognition.png?raw=true)

App desenvolvido com recursos do CoreML Tools e Conversão de modelos de Machine Learning para detectar imagens de determinadas flores. Demais dados são pesquisados com auxílio da lib Alamofire com o uso da API do Wikipedia.

Para o funcionamento adequado, primeiro é necessária fazer o download do modelo caffe-oxford102. Está disponível em: https://github.com/jimgoo/caffe-oxford102

Trata-se de um treinamento de redes neurais convolucionais profundas com Caffe para classificar imagens no conjunto de dados de flores da categoria Oxford 102.

A instalação requer o modelo no formato .mlmodel. Ele deve ser salvo no seguinte caminho do projeto: flowers-recognition/FlowerClassifier.mlmodel

A conversão pode ser feita com o python na versão 2.7. Este exemplo abaixo pode ser utilizado para criação do modelo no formato adequado:

    import coremltools
    caffe_model = ('oxford102.caffemodel', 'deploy.prototxt') 
    labels = 'flower-labels.txt'
    coreml_model = coremltools.converters.caffe.convert(
	    caffe_model,
	    class_labels=labels,
	    image_input_names='data'
	)
	coreml_model.save('FlowerClassifier.mlmodel')
