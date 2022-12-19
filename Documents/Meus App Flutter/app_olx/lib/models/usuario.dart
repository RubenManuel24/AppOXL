class Usuario{

  var _idUsuario;
  var _nome;
  var _email;
  var _senha;

  String get getIdUsuario => this._idUsuario;

  set setIdUsuario(String usuario){
    this._idUsuario = usuario;
  }

  String get getNome => this._nome;

  set setNome(String nome){
    this._nome = nome;
  }

  String get getEmail => this._email;

  set setEmail(String email){
    this._email = email;
  }

  String get getSenha => this._senha;

  set setSenha(String senha){
    this._senha = senha;
  }

  Map<String, dynamic> toMap(){

      Map<String, dynamic> map = {
         "idUsuario" : this._idUsuario,
         "nome"      : this._nome,
         "email"     : this._email,
      };

      return map;

  }

}