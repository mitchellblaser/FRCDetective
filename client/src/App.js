import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Link
} from 'react-router-dom';
import {Route} from 'react-router-dom';
import logo from './logo.svg';
import Header from './Components/Header';
import Footer from './Components/Footer';
import Home from './Views/Home';
import About from './Views/About';

function App() {
  return (
    <div className="App">
      <Router>
        <Header/>

        <div className='p-3'>
          <Routes>
            <Route path='/' element={<Home/>}/>
            <Route path='/about' element={<About/>}/>
          </Routes>
        </div>

        <Footer/>
      </Router>

    </div>
  );
}

export default App;
