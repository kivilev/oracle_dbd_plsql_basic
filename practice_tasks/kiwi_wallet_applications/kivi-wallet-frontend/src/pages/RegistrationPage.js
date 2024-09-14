import React, { useState } from 'react';
import { Container, Form, Button, Nav, Navbar, Alert } from 'react-bootstrap';

function RegistrationPage() {
  const [formData, setFormData] = useState({
    lastName: '',
    firstName: '',
    sureName: '',
    birthDay: '',
    email: '',
    inn: '',
    mobilePhone: '',
  });

  const [error, setError] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    // Валидация полей
    if (formData.lastName.length < 3 || formData.lastName.length > 30) {
      setError('Фамилия должна содержать от 3 до 30 символов.');
      return;
    }
    if (formData.firstName.length < 3 || formData.firstName.length > 30) {
      setError('Имя должно содержать от 3 до 30 символов.');
      return;
    }
    // Дополнительные проверки для других полей...

    const payload = {
      email: formData.email,
      birthDay: formData.birthDay,
      mobilePhone: formData.mobilePhone,
      lastName: formData.lastName,
      firstName: formData.firstName,
      inn: formData.inn,
    };

    if (formData.sureName) {
      payload.sureName = formData.sureName;
    }

    try {
      const response = await fetch('http://localhost:8080/api/v1/clients', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorData = await response.json();
        setError(`Ошибка: ${errorData.message || 'Не удалось зарегистрироваться.'}`);
        return;
      }

      const data = await response.json();
      window.location.href = `/lk?id=${data.clientId}`;
    } catch (err) {
      setError('Произошла ошибка при отправке данных.');
    }
  };

  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href="/">Главная страница</Nav.Link>
            <Nav.Link href="/reg">Регистрация пользователя</Nav.Link>
            <Nav.Link href="/lk">Вход в личный кабинет</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
      <Container className="mt-5">
        <h2>Регистрация пользователя</h2>
        {error && <Alert variant="danger">{error}</Alert>}
        <Form onSubmit={handleSubmit}>
          {/* Поля формы */}
          <Form.Group controlId="lastName">
            <Form.Label>Фамилия</Form.Label>
            <Form.Control
              type="text"
              name="lastName"
              value={formData.lastName}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="firstName">
            <Form.Label>Имя</Form.Label>
            <Form.Control
              type="text"
              name="firstName"
              value={formData.firstName}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="sureName">
            <Form.Label>Отчество</Form.Label>
            <Form.Control
              type="text"
              name="sureName"
              value={formData.sureName}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="birthDay">
            <Form.Label>Дата рождения</Form.Label>
            <Form.Control
              type="date"
              name="birthDay"
              value={formData.birthDay}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="email">
            <Form.Label>Email</Form.Label>
            <Form.Control
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="inn">
            <Form.Label>ИНН</Form.Label>
            <Form.Control
              type="text"
              name="inn"
              value={formData.inn}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="mobilePhone">
            <Form.Label>Мобильный телефон</Form.Label>
            <Form.Control
              type="text"
              name="mobilePhone"
              value={formData.mobilePhone}
              onChange={handleChange}
              required
            />
          </Form.Group>

          <Button variant="primary" type="submit" className="mt-3">
            Зарегистрироваться в системе
          </Button>
        </Form>
      </Container>
    </>
  );
}

export default RegistrationPage;
