import React from 'react';
import { Container, Nav, Navbar } from 'react-bootstrap';

function MainPage() {
  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href="/">Главная страница</Nav.Link>
            <Nav.Link href="/reg">Регистрация пользователя</Nav.Link>
            <Nav.Link href="/login">Вход в личный кабинет</Nav.Link> {/* Обновлено */}
          </Nav>
        </Container>
      </Navbar>
      <Container className="text-center mt-5">
        <h1>Добро пожаловать в Kivi-кошелек</h1>
      </Container>
    </>
  );
}

export default MainPage;
