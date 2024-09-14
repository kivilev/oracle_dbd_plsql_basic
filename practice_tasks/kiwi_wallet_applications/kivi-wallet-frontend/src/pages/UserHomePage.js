import React, { useEffect, useState } from 'react';
import { Container, Nav, Navbar, Alert } from 'react-bootstrap';
import { useSearchParams } from 'react-router-dom';

function UserHomePage() {
  const [searchParams] = useSearchParams();
  const clientId = searchParams.get('id');
  const [clientData, setClientData] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    fetch(`http://localhost:8080/api/v1/clients/${clientId}`)
      .then((res) => {
        if (!res.ok) {
          throw new Error('Клиент не найден.');
        }
        return res.json();
      })
      .then((data) => setClientData(data))
      .catch((err) => setError(err.message));
  }, [clientId]);

  if (error) {
    return (
      <Container className="mt-5">
        <Alert variant="danger">{error}</Alert>
      </Container>
    );
  }

  if (!clientData) {
    return null;
  }

  const { lastName, firstName, sureName } = clientData.clientData;
  const status = clientData.blocked ? 'заблокированный' : 'не заблокированный';
  const active = clientData.active ? 'активный' : 'не активный';

  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href={`/lk?id=${clientId}`}>Главная страница пользователя</Nav.Link>
            <Nav.Link href={`/payments?id=${clientId}`}>Платежи</Nav.Link>
            <Nav.Link href={`/prop?id=${clientId}`}>Настройки</Nav.Link>
            <Nav.Link href="/">Выход</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
      <Container className="text-center mt-5">
        <h1>
          Добро пожаловать, {lastName} {firstName} {sureName}!
        </h1>
        <p>
          Вы {status}, {active} клиент.
        </p>
      </Container>
    </>
  );
}

export default UserHomePage;