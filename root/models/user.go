package models

type User struct {
	Id    uint64 `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

func (u *User) Load(id uint64) {
	u.Id = id
	u.Name = "TODO"
	u.Email = "TODO"
}
