from fastapi import FastAPI, HTTPException
import mysql.connector
from pydantic import BaseModel

app = FastAPI()

# 1. Configuración de la Base de Datos (XAMPP)
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="mi_base_de_datos" # ¡Cambia esto por el nombre de tu BD en phpMyAdmin!
    )

# 2. Modelo de datos (Lo que esperas recibir de Flutter)
class Usuario(BaseModel):
    nombre: str
    email: str
    edad: int

# --- RUTA 1: LEER (SELECT) ---
@app.get("/usuarios")
def obtener_usuarios():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True) # dictionary=True ayuda a que Flutter entienda mejor el JSON
    
    # ==========================================
    # AQUÍ VA TU SENTENCIA SQL (LEER)
    # ==========================================
    sql = "SELECT * FROM usuarios" 
    cursor.execute(sql) 
    # ==========================================
    
    usuarios = cursor.fetchall()
    conn.close()
    return usuarios

# --- RUTA 2: CREAR (INSERT) ---
@app.post("/usuarios")
def crear_usuario(usuario: Usuario):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # ==========================================
    # AQUÍ VA TU SENTENCIA SQL (INSERTAR)
    # ==========================================
    # Los %s son marcadores de posición para evitar hackeos (SQL Injection)
    sql = "INSERT INTO usuarios (nombre, email, edad) VALUES (%s, %s, %s)"
    valores = (usuario.nombre, usuario.email, usuario.edad)
    cursor.execute(sql, valores)
    # ==========================================
    
    conn.commit() # ¡IMPORTANTE! Sin esto, no se guardan los cambios en XAMPP
    conn.close()
    return {"mensaje": "Usuario creado exitosamente"}

# --- RUTA 3: ACTUALIZAR (UPDATE) ---
@app.put("/usuarios/{user_id}")
def actualizar_usuario(user_id: int, usuario: Usuario):
    conn = get_db_connection()
    cursor = conn.cursor()

    # ==========================================
    # AQUÍ VA TU SENTENCIA SQL (ACTUALIZAR)
    # ==========================================
    sql = "UPDATE usuarios SET nombre = %s, email = %s, edad = %s WHERE id = %s"
    valores = (usuario.nombre, usuario.email, usuario.edad, user_id)
    cursor.execute(sql, valores)
    # ==========================================

    conn.commit()
    conn.close()
    return {"mensaje": "Usuario actualizado"}

# --- RUTA 4: BORRAR (DELETE) ---
@app.delete("/usuarios/{user_id}")
def borrar_usuario(user_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    # ==========================================
    # AQUÍ VA TU SENTENCIA SQL (BORRAR)
    # ==========================================
    sql = "DELETE FROM usuarios WHERE id = %s"
    valores = (user_id,) # La coma es necesaria si es un solo valor
    cursor.execute(sql, valores)
    # ==========================================

    conn.commit()
    conn.close()
    return {"mensaje": "Usuario eliminado"}