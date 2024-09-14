import React, { useState } from 'react';
import { Container, Form, Button, Nav, Navbar, Alert } from 'react-bootstrap';

function LoginPage() {
  const [clientId, setClientId] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!clientId) {
      setError('Пожалуйста, введите ID клиента.');
      return;
    }

    // Перенаправляем на страницу пользователя с введенным ID
    window.location.href = `/lk?id=${clientId}`;
  };

  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href="/">Главная страница</Nav.Link>
            <Nav.Link href="/reg">Регистрация пользователя</Nav.Link>
            <Nav.Link href="/login">Вход в личный кабинет</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
      <Container className="mt-5">
        <h2>Вход в личный кабинет</h2>
        {error && <Alert variant="danger">{error}</Alert>}
        <Form onSubmit={handleSubmit}>
          <Form.Group controlId="clientId">
            <Form.Label>ID клиента</Form.Label>
            <Form.Control
              type="text"
              value={clientId}
              onChange={(e) => setClientId(e.target.value)}
              required
            />
          </Form.Group>
          <Button variant="primary" type="submit" className="mt-3">
            Войти в личный кабинет
          </Button>
        </Form>
      </Container>
    </>
  );
}

export default LoginPage;
