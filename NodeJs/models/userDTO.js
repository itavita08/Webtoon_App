// JSdoc
/**
 * @constructor
 * @param {String} user_id - 사용자 아이디
 * @param {String} user_name - 사용자 이름
 * @param {String} user_password - 사용자 비밀번호
 */
class User {
    constructor(user_id, user_name, user_password) {
        this.user_id = user_id;
        this.user_name = user_name;
        this.user_password = user_password;
    }
    /**
     * @returns {User} user의 아이디, 이름, 비밀번호 전체 반환
     */
    getAll() {
        const user = new User(this.user_id, this.user_name, this.user_password);
        return user;
    }
    /**
     * @returns {String} user의 id 반환
     */
    getId() {
        return this.user_id;
    }
    /**
     * @returns {String} user의 name 반환
     */
    getName() {
        return this.user_name;
    }
    /**
     * @returns {String} user의 password 반환
     */
    getPassword() {
        return this.user_password;
    }
    /**
     * @returns {{user_id: String, user_password: String}}  user의 id와 password 반환
     */
    getIdandPassword() {
        const idAndPassword = {
            user_id: this.user_id,
            user_password: this.user_password
        };
        return idAndPassword;
    }
}





