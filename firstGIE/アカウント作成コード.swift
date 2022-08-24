//
//  アカウント作成コード.swift
//  firstGIE
//
//  Created by clark on 2022/06/07.
//

auth.createUser(withEmail: "メールアドレス", password: "パスワード") { (result, error) in
    // アカウント登録後に呼ばれる。
    // error変数が nil -> 成功
    //            nilではない -> 失敗
    // result変数 ... user情報などをプロパティとして格納している。
}
