# Linux Work Gamer Mode

Automação de ambientes de **trabalho e jogos no Linux**, utilizando **Bash + X11 + xrandr** para alterar automaticamente a configuração dos monitores e abrir os aplicativos necessários para cada ambiente.

> **Este projeto nasceu de uma necessidade minha:** alternar rapidamente entre meu ambiente de programação e meu ambiente de jogos sem precisar configurar os monitores e abrir os programas manualmente toda vez.
>
> **Use este projeto como uma ideia:** o conteúdo dos arquivos parte de uma configuração pessoal, sendo necessário adaptar rotas, comandos e configurações para cada usuário.

---

## Sobre o projeto

No meu setup, utilizo dois monitores com funções diferentes:

* **Monitor principal:** 1920×1080 @ 144 Hz, horizontal
* **Monitor secundário:** 1920×1080 @ 180 Hz, utilizado verticalmente

Durante o trabalho, utilizo os dois monitores:

```text
┌──────────┐   ┌──────────────────────┐
│          │   │                      │
│  180Hz   │   │        144Hz         │
│          │   │      PRINCIPAL       │
│ VERTICAL │   │                      │
│          │   │                      │
└──────────┘   └──────────────────────┘
```

Durante os jogos, utilizo somente o monitor principal.

Por isso, criei dois modos:

### Work Mode

* Ativa os dois monitores
* Coloca o monitor secundário na vertical
* Posiciona o monitor secundário à esquerda
* Mantém o monitor principal em 144 Hz
* Fecha aplicativos do modo gamer
* Abre VS Code
* Abre Brave

### Gamer Mode

* Desativa o monitor secundário
* Mantém o monitor principal em 144 Hz
* Fecha aplicativos do modo trabalho
* Abre a Steam

A troca pode ser feita através de atalhos de teclado.

---

# Como funciona

O projeto utiliza principalmente o `xrandr` para controlar as saídas de vídeo do X11.

No meu computador, os monitores são identificados como:

```text
DP-4 → monitor principal
DP-0 → monitor secundário
```

### Modo Trabalho

O comando utilizado é equivalente a:

```bash
xrandr --output DP-4 --primary --mode 1920x1080 --rate 144 \
       --output DP-0 --mode 1920x1080 --rate 180 \
       --rotate left --left-of DP-4
```

Ele configura:

* `DP-4` como monitor principal
* 1920×1080 @ 144 Hz no monitor principal
* `DP-0` em 1920×1080 @ 180 Hz
* rotação vertical do `DP-0`
* `DP-0` à esquerda do `DP-4`

### Modo Gamer

No modo gamer:

```bash
xrandr --output DP-4 --primary --mode 1920x1080 --rate 144 \
       --output DP-0 --off
```

O `DP-0` é desativado e somente o monitor principal permanece ativo.

---

# Requisitos

O projeto foi desenvolvido e testado no:

* **Zorin OS**
* **X11**
* Bash
* `xrandr`

### Importante: X11

Atualmente o projeto depende do `xrandr`, portanto foi desenvolvido para **sessões X11**.

> **Wayland não é suportado atualmente.**

Para verificar sua sessão:

```bash
echo $XDG_SESSION_TYPE
```

O resultado esperado é:

```text
x11
```

Você também precisa ter o `xrandr` instalado:

```bash
xrandr --version
```

---

# Compatibilidade com outras distribuições

Apesar de ter sido desenvolvido e testado no **Zorin OS**, o projeto não depende exclusivamente dele.

Ele pode funcionar em outras distribuições Linux que utilizem:

* X11
* Bash
* `xrandr`
* um ambiente gráfico compatível com arquivos `.desktop`

Por exemplo, outras distribuições baseadas em Debian ou Ubuntu podem ser compatíveis.

> **A compatibilidade não é garantida em todas as distribuições.** Os comandos para iniciar aplicativos, os ambientes gráficos e a identificação das saídas de vídeo podem variar.

O projeto atualmente é específico para **X11**, independentemente da distribuição utilizada.

---

# Adaptando para o seu computador

Este projeto foi criado a partir das necessidades específicas do meu setup. Os nomes dos monitores, resoluções, frequências e aplicativos utilizados não precisam ser iguais aos de outros usuários.

A ideia é utilizar o projeto como uma base e adaptar os scripts para cada computador.

## 1. Descobrindo os monitores

Execute:

```bash
xrandr --query
```

Procure pelas saídas que possuem:

```text
connected
```

Por exemplo:

```text
DP-1 connected
HDMI-1 connected
```

Esses nomes deverão substituir `DP-4` e `DP-0` nos scripts.

---

## 2. Descobrindo resolução e frequência

O próprio `xrandr` mostra as configurações disponíveis:

```bash
xrandr --query
```

Exemplo:

```text
1920x1080  60.00  144.00*
```

O `*` indica a configuração atualmente utilizada.

Os valores podem ser adaptados no script:

```bash
--mode 1920x1080 --rate 144
```

ou, por exemplo:

```bash
--mode 2560x1440 --rate 165
```

desde que o monitor suporte a configuração escolhida.

---

## 3. Posicionando os monitores

O `xrandr` permite definir a posição dos monitores utilizando:

```text
--left-of
--right-of
--above
--below
```

Por exemplo:

```bash
--left-of DP-4
```

coloca o monitor à esquerda do `DP-4`.

---

## 4. Alterando a orientação

Para utilizar um monitor verticalmente:

```bash
--rotate left
```

ou:

```bash
--rotate right
```

Para retornar à orientação horizontal:

```bash
--rotate normal
```

---

# Personalizando os aplicativos

Os scripts também podem ser adaptados para abrir os aplicativos utilizados em cada ambiente.

Por exemplo, no meu Work Mode:

```bash
code &
brave-browser &
```

Para adicionar outro aplicativo, basta adicionar seu comando:

```bash
discord &
```

ou:

```bash
spotify &
```

O comando necessário depende de como o aplicativo está instalado no sistema.

Para descobrir o comando de um aplicativo instalado normalmente, pode-se utilizar:

```bash
which nome-do-programa
```

Para aplicativos instalados via Flatpak:

```bash
flatpak list
```

E posteriormente:

```bash
flatpak run ID.DO.APLICATIVO &
```

### Exemplo: Steam

No meu sistema, a Steam está instalada via Flatpak.

Por isso, ela é iniciada com:

```bash
flatpak run com.valvesoftware.Steam &
```

---

# Fechamento dos aplicativos

Ao trocar de modo, os scripts fecham os aplicativos utilizados pelo modo anterior.

Por exemplo:

```bash
pkill -TERM brave
```

solicita o encerramento do Brave.

Para o VS Code:

```bash
pkill -TERM code
```

Para a Steam instalada via Flatpak:

```bash
flatpak kill com.valvesoftware.Steam
```

O projeto utiliza encerramento normal sempre que possível, evitando métodos mais agressivos como `kill -9`.

> **Atenção:** sempre salve seu trabalho antes de trocar de modo. O encerramento de aplicativos pode resultar na perda de alterações não salvas, dependendo do aplicativo.

---

# Atalhos

No meu sistema, configurei os seguintes atalhos:

```text
Super + W → Work Mode
Super + G → Gamer Mode
```

Os atalhos simplesmente executam os scripts correspondentes.

Exemplo:

```text
Super + W
    ↓
modo-trabalho.sh
    ↓
Configura os monitores
    ↓
Abre VS Code + Brave
```

E:

```text
Super + G
    ↓
modo-gamer.sh
    ↓
Configura o monitor
    ↓
Abre Steam
```

Os atalhos podem ser configurados pelas opções de teclado do ambiente gráfico utilizado.

---

# Estrutura do projeto

A estrutura atual do projeto é:

```text
linux-work-gamer-mode/
│
├── modo-trabalho.sh
├── modo-gamer.sh
├── modo-trabalho.desktop
├── modo-gamer.desktop
└── README.md
```

Os arquivos `.desktop` permitem que os scripts sejam executados através do menu de aplicativos do sistema.

---

# Por que este projeto existe?

Este projeto não pretende ser uma solução universal de gerenciamento de ambientes Linux.

Ele começou como uma **automação pessoal para resolver um problema específico do meu setup**.

A ideia era simples:

> "Quero mudar meu computador de ambiente de trabalho para ambiente gamer com um único comando."

A partir disso, a configuração dos monitores, abertura de aplicativos, fechamento de processos e atalhos foram automatizados.

A estrutura pode ser adaptada para diferentes necessidades.

Por exemplo:

### Ambiente de programação

```text
Work Mode
├── Monitor principal
├── Monitor secundário
├── VS Code
├── Brave
├── Discord
└── Terminal
```

### Ambiente de criação

```text
Work Mode
├── Monitor principal
├── Monitor secundário
├── Blender
├── GIMP
└── Firefox
```

### Ambiente gamer

```text
Gamer Mode
├── Monitor principal
├── Steam
├── Discord
└── OBS
```

A configuração de cada ambiente fica a critério do usuário.

---

# Limitações atuais

* O projeto depende de **X11 e `xrandr`**.
* **Wayland não é suportado atualmente.**
* Os nomes das saídas dos monitores precisam ser adaptados ao hardware.
* Resoluções e frequências dependem dos monitores utilizados.
* Os comandos para iniciar aplicativos podem variar entre instalações.
* A Steam utilizada no exemplo está instalada via Flatpak.
* O projeto foi desenvolvido originalmente para um setup específico.

---

# Possíveis melhorias

Algumas ideias para futuras versões:

* [ ] Suporte a Wayland
* [ ] Arquivo de configuração para facilitar a personalização
* [ ] Detecção automática dos monitores
* [ ] Verificação automática das dependências
* [ ] Detecção automática da instalação dos aplicativos
* [ ] Instalador automático
* [ ] Desinstalador
* [ ] Interface gráfica
* [ ] Mais modos além de Work/Gamer
* [ ] Configuração automática dos atalhos

## Licença

Este projeto está disponível sob a licença MIT.
Consulte o arquivo [LICENSE](LICENSE) para mais informações.
