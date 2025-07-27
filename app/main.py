from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# In-memory inventory list
inventory = []

@app.route('/')
def index():
    return render_template('index.html', inventory=inventory)

@app.route('/add', methods=['GET', 'POST'])
def add_item():
    if request.method == 'POST':
        name = request.form['name']
        quantity = int(request.form['quantity'])
        price = float(request.form['price'])
        inventory.append({'id': len(inventory)+1, 'name': name, 'quantity': quantity, 'price': price})
        return redirect(url_for('index'))
    return render_template('add_item.html')

@app.route('/edit/<int:item_id>', methods=['GET', 'POST'])
def edit_item(item_id):
    item = next((i for i in inventory if i['id'] == item_id), None)
    if not item:
        return 'Item not found', 404
    if request.method == 'POST':
        item['name'] = request.form['name']
        item['quantity'] = int(request.form['quantity'])
        item['price'] = float(request.form['price'])
        return redirect(url_for('index'))
    return render_template('edit_item.html', item=item)

@app.route('/delete/<int:item_id>')
def delete_item(item_id):
    global inventory
    inventory = [item for item in inventory if item['id'] != item_id]
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
