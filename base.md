Necessito de uma aplicação web com Docker e base de dados PostgresSql, para usar em portainer para fazer o levantamento de listas de registos paroquiais de batismo, casamento e óbito.
No fundo, o que vamos levantar para cada registo é o nome da pessoa em causa no ato (batizando, óbito) e do nome das pessoas referidas nesse registo que serão os pais e eventualmente os avós, e ainda intervenientes como padrinhos, madrinhas, padre e testemunhas...
Temos então estrutura de pessoas para os eventos Batismo e Óbito assim:

- Ano, Mês, Dia do evento
- Fonte do evento (para guardar o link para o documento online)
- Notas (texto livre para observações)

- Batizando / Defunto 	- Pai	- Avô paterno
		 		                - Avó paterna

	   		            - Mae 	- Avô materno
		 		                - Avó materna

			- Intervenientes
				- Padrinho
				- Madrinha
				- Testemunha
				- Padre
				(...)		  





E para o Casamento:

- Ano, Mês, Dia do evento
- Fonte do evento (para guardar o link para o documento online)
- Notas (texto livre para observações)

 - Noivo	- Pai	- Avô paterno
			        - Avó paterna
	   	    - Mae 	- Avô materno
			        - Avó materna		  

 - Noiva	- Pai	- Avô paterno
			        - Avó paterna
	   	    - Mae 	- Avô materno
			        - Avó materna		  

		- Intervenientes
			- Padrinho
			- Madrinha
			- Testemunha
			- Padre	
			(...)		

Cada um destes indivíduos e famílias têm de ter um ID único gerado automaticamente. Temos uma família gerada no casamento pela combinação do par noivo e noiva e também temos uma família por cada par de pais de um individuo referido, ou seja, o Pai e a Mae do Batizando / Defunto / Noivo / Noiva, formam uma família, e por sua vez os pais destes (avós do Batizando / Defunto / Noivo / Noiva) formam outra família. A relação de ascendentes faz-se através de um campo 'familia de origem', no Individuo, que indica o ID da família composta pelos pais desse indivíduo e assim sucessivamente. 
A cada das pessoas deve poder associar-se, para o evento em questão uma Alcunha (campo de texto livre) e uma profissão (a partir de uma lista de profissões já estabelecida).  Deve poder registar-se ainda uma naturalidade, um local de óbito e uma residência, todos a partir de uma lista e lugares já estabelecidos também (esta lista de lugares deve poder ser atualizada pelo utilizador). A lista de lugares esta também ligada a uma lista de paróquias, não editável,


Será necessário que a aplicação disponha de autenticação e mecanismo para a recuperação de password.
Cada introdução/edição de dados em qualquer tabela deverá registar o utilizador que introduziu/editou bem como a data hora em que isso aconteceu.
Este trabalho é realizado sempre no contexto de uma paróquia, pelo que cada evento deve ter uma 'paróquia de contexto' associada (da lista de paróquias já referida).
Os registos já levantados devem poder ser listados, reabertos e editados.

Pretendo uma aplicação com formulário simples e minimalista que permita ir adicionando elementos caso necessário, ou seja, podemos ter de raiz campos para a introdução do Indivíduo e dos Pais, mas no caso dos avós (pais dos pais) clicar-se num botão junto do pais / mãe  para adicionar os campos de registo dos avós. Idealmente esta construção já deveria ter um aspeto de árvore genealógica horizontal para facilitar a estruturação dos dados.

Podes propor uma estrutura de base de dados e de implementação de uma solução para esta finalidade?



 