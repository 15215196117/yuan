# -*- coding: utf-8 -*-
# all the imports
import os
import sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
app = Flask(__name__)
app.config.from_pyfile('config.py',silent=True)
def connect_db():
    """Connects to the specific database."""
    rv = sqlite3.connect(app.config['DATABASE'])
    rv.row_factory = sqlite3.Row
    return rv
'''
#创建数据库需要用到的函数 配置config 里面的数据库名字 sqlite3 直接为文件名 python consonl 下执行 from flaskr import init_db ;导入函数 init_db() ;执行函数生成sqlite3 数据库
def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()
'''
@app.route('/') #web.route falsk内置装饰器 对应url执行的函数
def show_entries(): #显示条目，
    cur = g.db.execute('select title, text from entries order by id desc')
    entries = [dict(title=row[0], text=row[1]) for row in cur.fetchall()]
    print entries,'楚河汉界',cur.fetchall()
    return render_template('show_entries.html', entries=entries)

@app.route('/add', methods=['POST'])
def add_entry(): #请求添加条目 http方法 POST
    if not session.get('logged_in'):
        abort(401)
    g.db.execute('insert into entries (title, text) values (?, ?)',
                 [request.form['title'], request.form['text']])
    g.db.commit()
    flash('New entry was successfully posted')
    return redirect(url_for('show_entries'))

@app.route('/login', methods=['GET', 'POST']) #用户登陆验证
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif request.form['password'] != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            session['logged_in'] = True
            flash('You were logged in')
            return redirect(url_for('show_entries'))
    return render_template('login.html', error=error)

@app.route('/logout')# 用户注销函数 session.pop 这里 这里会删除这个键值，如果没有就无操作 不用判断用户是否已经登陆
def logout():
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('show_entries'))

if __name__ == '__main__':
    app.run(host='127.0.0.1',port=80,debug=True)