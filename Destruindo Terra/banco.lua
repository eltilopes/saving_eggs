module(..., package.seeall)
sqlite = require ( "sqlite3" )
local pontos
function criarBd()
   path = system.pathForFile("banco.db", system.DocumentsDirectory)
   db = sqlite.open( path )
   db:exec( "CREATE TABLE IF NOT EXISTS tabela (id INTEGER PRIMARY KEY, score INTEGER);" )
   db:exec( "INSERT INTO tabela (id , score ) VALUES (1,10);" )
   db:exec( "INSERT INTO tabela (id , score ) VALUES (2,20);" )
   db:exec( "INSERT INTO tabela (id , score ) VALUES (3,30);" )
   db:exec( "INSERT INTO tabela (id , score ) VALUES (4,40);" )
   db:exec( "INSERT INTO tabela (id , score ) VALUES (5,50);" )
   print("O banco foi criado")
end

function insere(id, score)
   insert = "INSERT INTO tabela VALUES ('" .. id .. "', '" .. score .. "' );" 
   db:exec( insert ) -- Executa a inserção no banco
   print("inserido")
end

function atualiza(score)
   update = "UPDATE tabela SET score = '"..score.."' WHERE ID = 1;"
   db:exec(update)
   print("atualizado")
end

function lista()
   local point
   for row in db:nrows("SELECT score FROM tabela WHERE ID = 1;") do
    --txId   = display.newText(row.id .. " - ", 10, 30 * row.id, native.systemFont, 18) -- Texto que mostra o "id"
	--txNome = display.newText(row.score, 34, 30 , native.systemFont, 18) -- Texto que mostra o "nome"
	point = row.score
   end
   return point
end

function fecharBd()
    db:exec( "DROP TABLE tabela;")
	--db:close()

	print("tabela desfeita")
end

function setScore(numeroFase, pontos)
    score = pontos
end

function getScoreDaFase(numeroFase)
print(numeroFase)

	local pontos
	for row in db:nrows("SELECT score FROM tabela WHERE ID = '" .. numeroFase .. "';") do
	print(row.id)
		pontos = row.score
	end
	if ( pontos == nill ) then
		return 0
	end
	print(pontos)
	return pontos
end

function onSystemEvent( event )
	if( event.type == "applicationExit" ) then
	  db:close()
	end
	print("banco fechou")
end

Runtime:addEventListener( "system", onSystemEvent )
