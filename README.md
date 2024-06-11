# Compass Uol - Atividade AWS/Linux

## Descrição da Atividade

Este repositório contém a atividade de Linux do programa de bolsas da Compass UOL. A atividade é individual e envolve a implementação de requisitos específicos relacionados ao Linux e AWS, conforme descrito a seguir:

### Requisitos AWS:
1. Criar uma chave pública para acesso ao ambiente.
2. Configurar uma instância EC2 com Amazon Linux 2 (Tipo t3.small, 16 GB SSD).
3. Alocar um Elastic IP e associá-lo à instância EC2.
4. Abrir as portas necessárias para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).

### Requisitos no Linux:
1. Configurar o NFS fornecido.
2. Criar um diretório dentro do sistema de arquivos NFS com seu nome.
3. Instalar e configurar o Apache no servidor, garantindo que ele esteja ativo.
4. Desenvolver um script que verifica se o serviço está rodando e salva o resultado no diretório NFS.
5. O script deve registrar - Data e Hora + Nome do Serviço + Status + Mensagem personalizada de ONLINE ou OFFLINE.
6. O script deve criar dois arquivos de saída: um para o serviço online e outro para offline.
7. Configurar a execução automática do script a cada 5 minutos.
8. Versionar a atividade.
9. Documentar o processo de instalação do Linux.

---

## Índice
- [Descrição da Atividade](#descrição-da-atividade)
- [Configurações Iniciais na AWS](#configurações-iniciais-na-aws)
- [Gerar Par de Chaves para EC2](#gerar-par-de-chaves-para-ec2)
- [Criar a VPC](#criar-a-vpc)
- [Configurar Sub-Rede](#configurar-sub-rede)
- [Configurar o Gateway de Internet](#configurar-o-gateway-de-internet)
- [Configurar a Tabela de Roteamento](#configurar-a-tabela-de-roteamento)
- [Definir Regras de Segurança](#definir-regras-de-segurança)
- [Lançar a Instância EC2](#lançar-a-instância-ec2)
- [Associar IP Elástico à Instância EC2](#associar-ip-elástico-à-instância-ec2)
- [Configurar o NFS](#configurar-o-nfs)
- [Instalar e Configurar o Apache](#instalar-e-configurar-o-apache)
- [Referências](#referências)

---

## Passo a Passo de Implementação

### Configurações Iniciais na AWS
- Utilização de uma nova VPC para organização.
- Criação de um novo grupo de segurança.
- Configuração de uma nova sub-rede.
- Configuração de um gateway de internet.
- Detalhamento a seguir.

### Gerar Par de Chaves para EC2
Esta etapa é fundamental para o acesso remoto à instância EC2.

- Acesse o serviço EC2 na AWS e clique em "Pares de chaves" no menu à esquerda.
- Clique em "Criar par de chaves".
- Nomeie a chave, por exemplo, Chave-Projeto.
- Selecione o formato do arquivo como .pem para acesso via CMD.
- Clique em "Criar par de chaves".
- Salve o arquivo .pem gerado em um local seguro.

### Criar a VPC
- Acesse o serviço VPC na AWS, clique em "Suas VPCs" no menu à esquerda e depois em "Criar VPC".
- Selecione "Somente VPC" para configurar manualmente.
- Nomeie como VPC-PROJETO.
- Escolha "Entrada manual de CIDR IPv4" e insira 10.0.0.0/16.
- Deixe o bloco CIDR IPv6 como "Nenhum Bloco CIDR IPv6".
- Clique em "Criar VPC".

### Configurar Sub-Rede
- Acesse o serviço VPC na AWS, clique em "Sub-redes" no menu à esquerda e depois em "Criar Sub-rede".
- Selecione a VPC criada anteriormente.
- Nomeie a sub-rede como Sub-Projeto.
- Escolha a zona de disponibilidade us-east-1a.
- Insira 10.0.1.0/24 como o bloco CIDR IPv4 da sub-rede.
- Clique em "Criar Sub-rede".

### Configurar o Gateway de Internet
- Acesse o serviço VPC na AWS, clique em "Gateways de internet" no menu à esquerda e depois em "Criar gateway de internet".
- Nomeie como Projeto.
- Clique em "Criar gateway de internet".
- Selecione o gateway criado, clique em "Ações" e depois em "Associar à VPC".
- Escolha a VPC criada anteriormente e clique em "Associar".

### Configurar a Tabela de Roteamento
- Acesse o serviço VPC na AWS, clique em "Tabelas de rotas" no menu à esquerda e depois em "Criar tabela de rotas".
- Nomeie como Tab-Projeto.
- Associe a tabela à VPC criada anteriormente.
- Selecione a tabela de rotas criada, clique em "Ações" e depois em "Editar rotas".
- Adicione uma rota com os seguintes valores:
  - Destino: 0.0.0.0/0
  - Alvo: selecione o gateway de internet criado anteriormente.
- Clique em "Salvar" para concluir a configuração do tráfego de internet.

### Definir Regras de Segurança
- Acesse o serviço EC2 na AWS, clique em "Segurança" e depois em "Grupos de segurança" no menu à esquerda.
- Clique em "Criar grupo de segurança".
- Nomeie o grupo de segurança como ProjetoAWS.
- Adicione a descrição ProjetoAWS para organização.
- Associe à VPC criada anteriormente.
- Configure as regras de entrada clicando em "Adicionar nova regra" e adicionando as seguintes 7 regras:

![Regras de Tráfego de Internet na Tabela de Roteamento](regras-roteamento.jpeg)

### Lançar a Instância EC2
- Acesse o serviço EC2 na AWS, clique em "Instâncias" e depois em "Executar Instância".
- Na seção de nomes e tags, use os valores padrão (Name, Project e CostCenter) para instâncias e volumes.
- Escolha a imagem Amazon Linux 2 AMI (HVM), SSD Volume Type.
- Selecione t3.small como o tipo de instância.
- Selecione a chave gerada anteriormente (Chave-Projeto).
- Na configuração de rede, clique em "Editar" e verifique se a VPC e a sub-rede criadas estão selecionadas.
- Na seção de firewall, escolha "Selecionar grupo de segurança existente" e selecione ProjetoAWS.
- Para armazenamento, defina o tamanho como 16 GB gp2 (SSD).
- Clique em "Executar Instância".

### Associar IP Elástico à Instância EC2
Para que uma instância tenha um endereço IPv4 público estático, é necessário associar um IP elástico a ela.
- Acesse o serviço EC2 na AWS, clique em "IPs elásticos" no menu à esquerda.
- Clique em "Alocar endereço IP elástico".
- Selecione o IP alocado, clique em "Ações" e depois em "Associar endereço IP elástico".
- Escolha a instância EC2 criada anteriormente e clique em "Associar".

### Ajustando acesso ao NFS
O NFS é uma solução de armazenamento em rede amplamente empregada para compartilhar informações através da rede. Na AWS, essa funcionalidade é oferecida pelo EFS (Elastic File System).
- Primeiramente, vamos atualizar o sistema e instalar os utilitários necessários do NFS:
  - `sudo yum update -y` 
  em seguida
  - `sudo yum install -y nfs-utils`

- Após esse passo, criaremos um diretório para o NFS, usando o seguinte comando:
  - `sudo mkdir -p /nfs/gabriel`

- Uma vez criado o diretório, vamos ajustar as permissões:
  - `sudo chown nobody:nobody /nfs/gabriel`
  e em seguida
  - `sudo chmod 777 /nfs/gabriel`

- Agora vamos configurar o compartilhamento do NFS desta forma:
  - `echo "/nfs/gabriel *(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports`

- Após isso, exportaremos os sistemas de arquivo utilizando:
  - `sudo exportfs -a`
  
- Por fim, para completar a configuração do NFS, iniciaremos e habilitaremos os serviços com os seguintes comandos:
  - `sudo systemctl start nfs-server`
  e então
  - `sudo systemctl enable nfs-server`

### Ajustando o Apache
- Comecei instalando o apache com o comando:
  - `sudo yum install -y httpd`

- Depois, iniciei e habilitei os serviços do Apache com:
  - `sudo systemctl start httpd`
  e então
  - `sudo systemctl enable httpd`

- Feito isso, criei um diretório para o script:
  - `sudo mkdir -p /usr/local/bin/`

- Agora, criei um script para validação:
  ```bash
  sudo nano /usr/local/bin/verifica_apache.sh

  #!/bin/bash
  DIR_NFS="/nfs/gabriel"
  DATE=$(date '+%Y-%m-%d %H:%M:%S')
  SERVICE="httpd"
  STATUS=$(systemctl is-active $SERVICE)

  if [ "$STATUS" == "active" ]; then
    MESSAGE="ONLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/online.log
  else
    MESSAGE="OFFLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/offline.log
  fi

- Após isso, tornei o script executável utilizando o comando:
  - `sudo chmod +x /usr/local/bin/verifica_apache.sh`

- Feito isso, configurei o cron para que o script seja executado automaticamente a cada 5 minutos com privilégios de root:
  - `sudo crontab -e`
  
Código de configuração do cron:
  - `*/5 * * * * /usr/local/bin/verificar_apache.sh`
    

### Conclusão
Com essas etapas concluímos a configuração. Uma maneira de verificar se o Apache está funcionando corretamente é acessar o IP público da instância e verificar se a página do Apache é exibida.
