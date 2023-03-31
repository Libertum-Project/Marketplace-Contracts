1- crear nfts --- ID 0 y 1

2. crear token---

3. desplegar FeeBeneficiary -- colocar la wallet a donde van los fondos y el porcentaje (dentro del contrato tiene funciones para mas wallets y mas porcentajes) 
ES MUY IMPORTANTE DESPLEGAR ESTE CONTRATO Y SETEARLO EN EL MARKETPLACE FIXEDPRICE PORQUE SINO, VA A DAR ERROR O NO VA A DISTRIBUIR FONDOS EN EL MEJOR DE LOS CASOS.

4- desplegar MARKETPLACE FIXEDPRICE
el constructor pide whitelistedtokens ese parametro es para los CONTRATOS DE NFT´S QUE SE VAN A COMERCIALIZAR EN EL MARKETPLACE, se puede iniciar con un contrato para el despliegue y posterior al despliegue esta la funcion whitelist para agregar otros contratos, esto es para que no cualquier contrato de propiedad se use, sino solamente aquellos que sean aprobados por la empresa y posteriormente habilitar un whitelist automatizado.
el parametro debe ser ingresado entre corchetes [] y entre comillas "" en el caso de ser varios contratos con una coma en el medio, ej: ["xxxxxxxxxxx","xxxxxxxxxxx"]


el parametro CURRENCY es para la moneda que se va a usar como moneda de pago.


5- APROBAR LOS CONTRATOS INTELIGENTES------
aprobar marketplace en el token y nft
aprobar feebeneficiary en el token
setear feebeneficiary como feecontract en el marketplace fixed price (funcion set feeaddress)
setear dentro del contrato feebeneficiary al contrato marketplace fixed price como addressbeneficiary y agregar las wallets donde iran la liquides etc. ESTO ES MUY IMPORTANTE DEBIDO A QUE SI NO SE SETEA EL CONTRATO FEEBENEFICIARY NO PODRAN EJECUTAR LA funcion PURCHASE (COMPRA) POR LA FALTA DE LUGAR DONDE DEPOSITAR LOS FONDOS.


6- funcion LIST
token: es el contrato del nft
ID: id del nft (recordar que inicia en el numero 0)
price: precio a pagar por el nft



7 funcion PURCHASE
address del nft
id del nft 
RECORDAR SETEAR LAS WALLETS QUE RECIBEN FEE Y SETEAR EL CONTRATO DE FEEBENEFICIARY SINO ESTA FUNCION VA A FALLAR POR EL MODIFIER.

8- funcion Unlist, es lis al contrario :VVVV


9- otras funciones_ 
blacklist es para que contratos de nft no deseados, no publiquen en el market
listinlotes y unlistinlotes es para listar y desenlistar en el market varios contratos tipo coleccion
renounceowner, transferowner, pause, aprove, funciones estandar openzeppelin
set currency setear
setfeeaddres para agregar el feebeneficiary (vease puntos anteriores)
whitelisttoken para agregar nft que puedan ser comercializados.
