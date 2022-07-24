-- Base de dades Universidad

USE universidad;

-- 1.Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. 
-- El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.

SELECT apellido1, apellido2, nombre, tipo FROM persona 
WHERE tipo LIKE 'alumno' ORDER BY apellido1 ASC,apellido2 ASC, nombre ASC;

-- 2.Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.

SELECT nombre,apellido1,telefono FROM persona 
WHERE tipo LIKE 'alumno'  AND telefono IS NULL;

-- 3.Retorna el llistat dels alumnes que van néixer en 1999.

SELECT apellido1, apellido2, nombre,date_format(fecha_nacimiento,'%Y') AS 'Any' FROM persona
WHERE tipo LIKE 'alumno'  AND date_format(fecha_nacimiento,'%Y') LIKE '1999' ;

-- 4.Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon
-- en la base de dades i a més el seu NIF acaba en K.

SELECT apellido1, apellido2, nombre,nif, telefono FROM persona 
WHERE tipo LIKE 'profesor'  AND telefono IS NULL
AND  instr(upper(nif),'K')!=0;

-- 5.Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, 
-- en el tercer curs del grau que té l'identificador 7.

SELECT a.nombre AS Asignatura, a.id_grado AS grado, a.curso AS curso, a.cuatrimestre AS cuatrimestre FROM asignatura AS a
where a.id_grado=7 
AND a.cuatrimestre=1 
AND a.curso=3;
 
-- 6.Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. 
-- El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
-- El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.

SELECT p.apellido1, p.apellido2, p.nombre ,d.nombre AS departamento 
FROM persona AS p, departamento AS d, profesor AS pr
WHERE p.tipo='profesor'
AND p.id=pr.id_profesor
AND pr.id_departamento=d.id
ORDER BY p.apellido1 ASC,p.apellido2 ASC, p.nombre ASC;

-- 7.Retorna un llistat amb el nom de les assignatures, 
-- any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.

SELECT a.nombre,c.anyo_inicio, c. anyo_fin FROM asignatura as a,alumno_se_matricula_asignatura AS al_as, persona AS p, curso_escolar AS c
where p.tipo='alumno'
AND p.id=al_as.id_alumno
AND al_as.id_asignatura=a.id
AND al_as.id_curso_escolar=c.id
AND p.nif LIKE '26902806M';

-- 8.Retorna un llistat amb el nom de tots els departaments que tenen professors/es
-- que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).



SELECT DISTINCTROW d.nombre 
FROM asignatura AS a, grado AS g, profesor AS p, departamento AS d
WHERE g.id=a.id_grado
AND  a.id_profesor=p.id_profesor
AND d.id=p.id_departamento
AND g.nombre='Grado en Ingeniería Informática (Plan 2015)';

-- 9.Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.

SELECT DISTINCTROW p.nombre, p.apellido1, p.apellido2 FROM persona as p,alumno_se_matricula_asignatura AS asm, curso_escolar AS c
WHERE p.id=asm.id_alumno
AND asm.id_alumno= p.id
AND asm.id_curso_escolar=c.id
AND c.anyo_inicio = '2018'
AND c.anyo_fin='2019';

SELECT  p.nombre, p.apellido1, p.apellido2 FROM persona as p,alumno_se_matricula_asignatura AS asm, curso_escolar AS c
WHERE p.id=asm.id_alumno
AND asm.id_alumno= p.id
AND asm.id_curso_escolar=c.id
AND c.anyo_inicio = '2018'
AND c.anyo_fin='2019'
GROUP BY p.nombre, p.apellido1, p.apellido2;

-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.

/*
1.Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats.
El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. 
El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. 
El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom
*/

SELECT d.nombre AS departamento,  p.apellido1, p.apellido2, p.nombre   FROM persona AS p
LEFT JOIN  profesor AS pro ON p.id=pro.id_profesor
LEFT JOIN departamento as d ON pro.id_departamento=d.id
ORDER BY d.nombre ASC, p.apellido1 ASC, p.apellido2 ASC;

-- 2.Retorna un llistat amb els professors/es que no estan associats a un departament.

SELECT   p.apellido1, p.apellido2, p.nombre  FROM persona AS p
LEFT JOIN  profesor AS pro ON p.id=pro.id_profesor
WHERE pro.id_departamento IS NULL
ORDER BY  p.apellido1 ASC, p.apellido2, p.nombre ASC;

-- 3.Calcula quants professors/es hi ha en cada departament.
-- El resultat només ha de mostrar dues columnes, una amb el nom del departament 
-- i una altra amb el nombre de professors/es que hi ha en aquest departament.
-- El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà
--  d'estar ordenat de major a menor pel nombre de professors/es.



SELECT d.nombre AS departament,count(d.nombre) AS 'nombre professors' FROM departamento AS d
INNER JOIN profesor AS pro ON d.id=pro.id_departamento
GROUP BY d.nombre
ORDER BY count(d.nombre) ASC, d.nombre ASC;

-- 4.Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells.
-- Tingui en compte que poden existir departaments que no tenen professors/es associats.
-- Aquests departaments també han d'aparèixer en el llistat.

SELECT   d.nombre AS departament , if(pr.id_profesor IS NULL,0,count(d.nombre))  AS 'nombre profesors' 
FROM profesor AS pr
RIGHT JOIN departamento AS d ON pr.id_departamento=d.id
GROUP BY d.nombre;

-- 5.Retorna un llistat amb les assignatures que no tenen un professor/a assignat.

SELECT nombre FROM asignatura WHERE id_profesor IS NULL;

-- 6.Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.

SELECT   ce.id, d.nombre  FROM departamento AS d
LEFT JOIN profesor  AS pr ON d.id= pr.id_departamento 
LEFT JOIN asignatura AS a ON pr.id_profesor=a.id
LEFT JOIN alumno_se_matricula_asignatura AS asm ON a.id=asm.id_asignatura
LEFT JOIN curso_escolar AS ce ON asm.id_curso_escolar=ce.id
GROUP BY d.nombre HAVING ce.id IS NULL;


 -- Consultes resum:

-- 1.Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(id)AS 'Nombre alumnes'FROM persona 
WHERE  tipo='alumno';

-- 2.Calcula quants alumnes van néixer en 1999.

SELECT COUNT(id)AS 'Nombre alumnes',
	(SELECT COUNT(id) AS 'nascuts 1999' FROM persona
    WHERE year( fecha_nacimiento)='1999') AS 'Nascuts 1999'
    FROM persona 
    WHERE  tipo='alumno';
    
    
-- 3.Calcula quants professors/es hi ha en cada departament.
-- El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament.
-- El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.

    
SELECT d.nombre,count(d.nombre) AS 'Nombre profs.' FROM departamento AS d
INNER JOIN profesor AS p ON d.id=p.id_departamento
GROUP BY d.nombre 
ORDER BY count(d.nombre) DESC;

-- 4.Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells.
-- Tingui en compte que poden existir departaments que no tenen professors/es associats.
-- Aquests departaments també han d'aparèixer en el llistat.
 

SELECT d.nombre,if(p.id_profesor IS NOT NULL,count(d.nombre),0) AS 'Nombre profs.' FROM departamento AS d
LEFT JOIN profesor AS p ON d.id=p.id_departamento
GROUP BY d.nombre ;


-- 5.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
-- Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. 
-- El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.

SELECT  g.nombre AS grau ,IF(a.nombre IS NOT NULL,COUNT(*),0) as 'nombre' FROM grado as g
LEFT JOIN asignatura AS a ON g.id = a.id_grado
GROUP BY g.nombre 
ORDER BY nombre asc;

-- 6.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun,
-- dels graus que tinguin més de 40 assignatures associades.

SELECT  g.nombre AS grau ,COUNT(*) as 'nombre' FROM grado as g
INNER JOIN asignatura AS a ON g.id = a.id_grado
GROUP BY g.nombre  HAVING COUNT(*) > 39;

-- 7.Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
-- El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que 
-- hi ha d'aquest tipus.


SELECT g.nombre as grau , a.tipo as tipus , SUM(creditos) as suma_credits
FROM asignatura AS a
INNER JOIN grado as g ON a.id_grado=g.id
GROUP BY g.nombre, a.tipo
ORDER BY g.nombre ASC;

-- 8.Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
-- El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.

SELECT cursos.any_inici_curs  ,count(cursos.any_inici_curs) AS 'alumnes matriculats' 
FROM (SELECT   asm.id_alumno,ce.anyo_inicio AS any_inici_curs FROM curso_escolar as ce
INNER JOIN alumno_se_matricula_asignatura AS asm ON ce.id=asm.id_curso_escolar
GROUP BY asm.id_alumno ) AS cursos
GROUP BY cursos.any_inici_curs;

-- 9.Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. 
-- El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. 
-- El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. 
-- El resultat estarà ordenat de major a menor pel nombre d'assignatures.



SELECT p.id,p.nombre, p.apellido1,p.apellido2, IF(a.id_profesor IS NOT NULL, count(p.id),0) AS asignatures FROM persona AS p
CROSS JOIN profesor AS pr ON p.id=pr.id_profesor
LEFT JOIN asignatura AS a ON pr.id_profesor= a.id_profesor
WHERE p.tipo LIKE 'profesor'
GROUP BY p.id
ORDER BY asignatures DESC;

-- 10.Retorna totes les dades de l'alumne/a més jove.

SELECT * FROM persona
WHERE tipo LIKE 'alumno' HAVING MIN(fecha_nacimiento);

-- 11.Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.


SELECT d.nombre AS departamento  ,p.nombre ,p.apellido1,p.apellido2 FROM persona AS p
INNER JOIN profesor  AS pr  ON p.id=pr.id_profesor  
INNER JOIN departamento as d ON pr.id_departamento =d.id
LEFT JOIN asignatura AS a ON pr.id_profesor=a.id_profesor
WHERE a.id IS NULL
